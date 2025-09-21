# app.py
import os
import google.generativeai as genai
import base64
from flask import Flask, request, jsonify

# Corrected: Configure the API key using the environment variable name
genai.configure(api_key=os.environ["GEMINI_API_KEY"])

app = Flask(__name__)

# New: Route for Smart Product Cataloging
@app.route('/api/generate-product-listing', methods=['POST'])
def generate_product_listing():
    data = request.json
    product_name = data.get('productName')
    image_data_b64 = data.get('imageData')

    if not product_name or not image_data_b64:
        return jsonify({"error": "Missing product name or image data"}), 400

    try:
        # Decode the Base64 image data
        image_bytes = base64.b64decode(image_data_b64)
        
        # Create a GenerativeModel with vision capabilities
        model = genai.GenerativeModel('gemini-1.5-flash')
        
        # Build the multi-modal content
        prompt = f"You are an expert in e-commerce product listings. Based on the product named '{product_name}' and the image, generate a compelling product description (at least 50 words) and a list of 5-8 relevant tags. Use a professional tone. The tags should be a comma-separated list at the end."
        
        image_part = {
            'mime_type': 'image/jpeg',
            'data': image_bytes
        }
        
        response = model.generate_content([prompt, image_part])

        # Separate the description and tags from the response
        generated_content = response.text.strip()
        
        parts = generated_content.rsplit('\n', 1)
        description = parts[0].strip()
        tags_raw = parts[1].strip() if len(parts) > 1 else ""
        tags = [tag.strip() for tag in tags_raw.split(',') if tag.strip()]

        return jsonify({
            "description": description,
            "tags": tags
        })

    except Exception as e:
        print(f"Error occurred in generate_product_listing: {e}")
        return jsonify({"error": str(e)}), 500

# Existing routes (gemini_chat and generate_profile) go here...
@app.route('/api/generate-profile', methods=['POST'])
def generate_profile():
    data = request.json
    artisan_name = data.get('name')
    craft_type = data.get('craft')

    if not artisan_name or not craft_type:
        return jsonify({"error": "Missing name or craft type"}), 400

    prompt = f"Write a professional, creative, and inspiring bio for a traditional Indian artisan named {artisan_name} who specializes in {craft_type}. Do not use any gendered pronouns or language. The bio should be gender-neutral and professional. Include a catchy tagline for their online shop."

    try:
        model = genai.GenerativeModel('gemini-1.5-flash')
        response = model.generate_content(prompt)
        
        # Check if the response is a valid string before returning
        if response.text:
            return jsonify({"bio": response.text})
        else:
            return jsonify({"error": "AI response was empty or invalid."}), 500

    except Exception as e:
        print(f"Error occurred in generate_profile: {e}")
        return jsonify({"error": f"An internal error occurred: {str(e)}"}), 500

# Route for the chatbot feature
@app.route('/api/gemini-chat', methods=['POST'])
def gemini_chat():
    data = request.json
    user_message = data.get('message')

    if not user_message:
        return jsonify({"error": "No message provided"}), 400

    try:
        model = genai.GenerativeModel('gemini-1.5-flash')
        response = model.generate_content(user_message)

        return jsonify({"response": response.text})

    except Exception as e:
        print(f"Error occurred in gemini_chat: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)