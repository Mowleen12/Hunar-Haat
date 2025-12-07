# app.py - FULLY FIXED VERSION (Nov 2025 Compatible)
import os
import base64
import logging
import socket
from flask import Flask, request, jsonify
from flask_cors import CORS
import google.generativeai as genai
from google.generativeai.types import Tool, FunctionDeclaration  # FIXED: Import from types
from typing import Optional

# --- CONFIGURATION ---
API_KEY = os.environ.get("GEMINI_API_KEY")
GEMINI_MODEL = "gemini-2.0-flash"  # Updated to available model
PORT = int(os.environ.get("PORT", 5000))

app = Flask(__name__)
CORS(app)

# --- LOGGING SETUP ---
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger(__name__)

# --- INITIALIZE GEMINI ---
if not API_KEY:
    logger.error("❌ GEMINI_API_KEY not set! Set it as environment variable.")
else:
    try:
        genai.configure(api_key=API_KEY)
        logger.info("✅ Gemini API initialized successfully")
        
        # DEBUG: List available models
        logger.info("🔍 Checking available models...")
        with open("models.txt", "w") as f:
            for m in genai.list_models():
                if 'generateContent' in m.supported_generation_methods:
                    logger.info(f"   - {m.name}")
                    f.write(f"{m.name}\n")
                
    except Exception as e:
        logger.error(f"❌ Failed to initialize Gemini: {e}")


# --- MOCK DATABASE ---
def get_recommendations_from_mock_db(
    k: int = 4, 
    category: Optional[str] = None, 
    max_price: Optional[int] = None
) -> list:
    """Mock database function for product recommendations"""
    category_display = category if category else "Crafts"
    price_note = f" (under ₹{max_price})" if max_price and max_price < 2000 else ""

    mock_products = [
        {
            "id": "ART-001",
            "name": f"Hand-Painted {category_display} Wall Hanging",
            "price": 1800,
            "artisan": "Rajesh Arts",
            "region": "Jaipur"
        },
        {
            "id": "ART-002",
            "name": f"Intricate {category_display} Bangle Set",
            "price": 450,
            "artisan": "Shilpa Textiles",
            "region": "Gujarat"
        },
        {
            "id": "ART-003",
            "name": f"Jaipur Blue {category_display} Coaster Set",
            "price": 799,
            "artisan": "Kumbhar Pottery",
            "region": "Rajasthan"
        },
        {
            "id": "ART-004",
            "name": f"Kashmiri Pashmina {category_display} Scarf",
            "price": 3500,
            "artisan": "Himalayan Weavers",
            "region": "Kashmir"
        },
        {
            "id": "ART-005",
            "name": f"Tribal Dokra {category_display} Figure",
            "price": 1200,
            "artisan": "Orissa Artists",
            "region": "Odisha"
        },
    ]

    if max_price is not None:
        filtered = [p for p in mock_products if p["price"] <= max_price]
        for p in filtered:
            p["name"] += price_note
        return filtered[:k]

    return mock_products[:k]


# --- RECOMMENDATION TOOL EXECUTOR ---
def recommend_products_for_user(category: str, max_price: int, k: int = 4) -> str:
    """Execute product recommendation tool"""
    recommendations = get_recommendations_from_mock_db(
        k=k, 
        category=category, 
        max_price=max_price
    )
    
    result = f"Found {len(recommendations)} items for '{category}' (max ₹{max_price}):\n\n"
    for r in recommendations:
        result += f"• {r['name']}\n"
        result += f"  Artisan: {r['artisan']} | Region: {r['region']} | Price: ₹{r['price']}\n\n"
    
    return result


# --- FUNCTION DECLARATION (Correct Import & Syntax) ---
recommend_products_declaration = FunctionDeclaration(
    name="recommend_products_for_user",
    description="Fetch handcrafted product recommendations based on category and price.",
    parameters={
        "type": "object",
        "properties": {
            "category": {
                "type": "string",
                "description": "Craft type (e.g., Pottery, Jewelry, Textiles)."
            },
            "max_price": {
                "type": "integer",
                "description": "Maximum price in Rupees."
            },
            "k": {
                "type": "integer",
                "description": "Number of items to return (default 4)."
            },
        },
        "required": ["category", "max_price"],
    },
)

recommend_products_tool = Tool(
    function_declarations=[recommend_products_declaration]
)


# --- HEALTH CHECK ---
@app.route("/", methods=["GET"])
def health_check():
    """Health check endpoint"""
    return jsonify({
        "status": "running",
        "service": "Hunar Haat AI Backend",
        "version": "1.0.0",
        "endpoints": [
            "/api/gemini-chat",
            "/api/generate-product-listing",
            "/api/generate-profile"
        ]
    })


# --- CHAT ENDPOINT ---
@app.route("/api/gemini-chat", methods=["POST"])
def gemini_chat():
    """Handle chat messages with Gemini AI"""
    try:
        data = request.json
        user_message = data.get("message")

        if not user_message:
            return jsonify({"error": "No message provided"}), 400

        if not API_KEY:
            return jsonify({"response": "API key not configured"}), 503

        logger.info(f"📩 Chat request: {user_message[:50]}...")

        # Initialize model with tool
        model = genai.GenerativeModel(
            GEMINI_MODEL,
            tools=[recommend_products_tool]
        )

        response = model.generate_content(user_message)

        # Check if model wants to call function
        if response.candidates and response.candidates[0].content.parts:
            part = response.candidates[0].content.parts[0]
            if hasattr(part, 'function_call') and part.function_call:
                fc = part.function_call
                
                if fc.name == "recommend_products_for_user":
                    # Execute function
                    args = dict(fc.args)
                    result = recommend_products_for_user(**args)

                    # Send result back to model for final response
                    second_prompt = f"User asked: {user_message}\nFunction result: {result}\nProvide a natural response incorporating the recommendations."
                    final_response = model.generate_content(second_prompt)
                    logger.info("✅ Function call completed")
                    return jsonify({"response": final_response.text})

        logger.info("✅ Chat response generated")
        return jsonify({"response": response.text})

    except Exception as e:
        logger.exception("❌ Error in gemini_chat")
        return jsonify({"error": f"AI error: {str(e)}"}), 500


# --- PRODUCT LISTING GENERATION ---
@app.route("/api/generate-product-listing", methods=["POST"])
def generate_product_listing():
    """Generate product description and tags from image"""
    try:
        data = request.json
        product_name = data.get("productName")
        image_base64 = data.get("imageData")
        category = data.get("category", "")
        price = data.get("price", "")

        if not product_name or not image_base64:
            return jsonify({"error": "Missing product name or image"}), 400

        logger.info(f"📦 Generating listing for: {product_name}")

        # Decode image (handle data URL prefix if present)
        if image_base64.startswith("data:image"):
            image_base64 = image_base64.split(",")[1]
        image_bytes = base64.b64decode(image_base64)

        # Create prompt
        prompt = (
            f"Analyze this product image for '{product_name}'"
            f"{f' in category {category}' if category else ''}"
            f"{f' priced at ₹{price}' if price else ''}.\n\n"
            "Generate:\n"
            "1. A compelling 50-word product description highlighting craftsmanship\n"
            "2. 5-8 relevant tags (comma-separated)\n\n"
            "Format:\n"
            "DESCRIPTION: [your description]\n"
            "TAGS: tag1, tag2, tag3, ..."
        )

        # Call Gemini with image
        model = genai.GenerativeModel(GEMINI_MODEL)
        image_part = {"mime_type": "image/jpeg", "data": image_bytes}
        response = model.generate_content([prompt, image_part])

        text = response.text.strip()

        # Parse response
        description = ""
        tags = []

        for line in text.split("\n"):
            if line.startswith("DESCRIPTION:"):
                description = line.replace("DESCRIPTION:", "").strip()
            elif line.startswith("TAGS:"):
                tags_text = line.replace("TAGS:", "").strip()
                tags = [t.strip() for t in tags_text.split(",")]

        # Fallback parsing
        if not description or not tags:
            parts = text.split("\n", 1)
            description = parts[0].strip()
            if len(parts) > 1:
                tags = [t.strip() for t in parts[1].split(",")]

        logger.info(f"✅ Generated listing with {len(tags)} tags")
        return jsonify({
            "description": description,
            "tags": tags
        })

    except Exception as e:
        logger.exception("❌ Error generating product listing")
        return jsonify({"error": f"Generation error: {str(e)}"}), 500


# --- ARTISAN PROFILE GENERATION ---
@app.route("/api/generate-profile", methods=["POST"])
def generate_profile():
    """Generate artisan bio using AI"""
    try:
        data = request.json
        name = data.get("name")
        craft = data.get("craft")
        location = data.get("location", "")
        experience = data.get("experience", "")

        if not name or not craft:
            return jsonify({"error": "Missing name or craft"}), 400

        logger.info(f"👤 Generating profile for: {name}")

        # Create prompt
        prompt = (
            f"Create a professional, creative artisan bio for {name}, "
            f"who specializes in {craft}"
            f"{f' from {location}' if location else ''}"
            f"{f' with {experience} years of experience' if experience else ''}.\n\n"
            "Requirements:\n"
            "- 100-150 words\n"
            "- Gender-neutral language\n"
            "- Highlight craftsmanship and tradition\n"
            "- Include a catchy tagline at the end\n"
            "- Professional yet warm tone"
        )

        model = genai.GenerativeModel(GEMINI_MODEL)
        response = model.generate_content(prompt)

        logger.info("✅ Profile generated")
        return jsonify({"bio": response.text.strip()})

    except Exception as e:
        logger.exception("❌ Error generating profile")
        return jsonify({"error": f"Generation error: {str(e)}"}), 500


# --- ERROR HANDLERS ---
@app.errorhandler(404)
def not_found(e):
    return jsonify({"error": "Endpoint not found"}), 404


@app.errorhandler(500)
def internal_error(e):
    return jsonify({"error": "Internal server error"}), 500


# --- RUN SERVER ---
if __name__ == "__main__":
    logger.info(f"🚀 Starting Hunar Haat Backend on port {PORT}")
    logger.info(f"📡 API Key configured: {'Yes ✅' if API_KEY else 'No ❌'}")
    
    # Show local IP for phone connection
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
        print("Backend running! Connect from your phone using:")
        print(f"   http://{local_ip}:{PORT}")
        print(f"   http://localhost:{PORT} (only on this PC)")
    except Exception as e:
        print(f"   Could not detect IP: {e}")
    
    app.run(
        host="0.0.0.0",
        port=PORT,
        debug=True,
        threaded=True
    )