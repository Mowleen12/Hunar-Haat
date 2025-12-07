import os
import google.generativeai as genai

print("--- Script Starting ---")

# Configure the API key
API_KEY = os.getenv("GEMINI_API_KEY")

try:
    if not API_KEY:
        raise KeyError("GEMINI_API_KEY is not set.")
    
    # This line attempts to read the environment variable
    genai.configure(api_key=API_KEY)
    
except KeyError:
    print("ERROR: The GEMINI_API_KEY environment variable is NOT set. Please set it and try again.")
    # Use os._exit(1) to ensure termination outside of a Flask context
    os._exit(1) 
    

def list_available_models():
    """Prints a list of all models available via the API that support content generation."""
    print("--- Attempting to call list_models() ---")
    
    try:
        # THE MISSING CORE LOGIC: Iterate through the models returned by the API
        for model in genai.list_models():
            # Filter for models that can actually generate text/content
            if 'generateContent' in model.supported_generation_methods:
                # Print the model name (the string you must use in your code)
                print(f"✅ Supported Model Name: {model.name}")
                print(f"  Description: {model.description.split('.')[0]}")
                print("-" * 30)
                
    except Exception as e:
        print(f"FATAL API ERROR during list_models: {e}")
        print("This often means your API key is invalid or has network restrictions.")


if __name__ == '__main__':
    list_available_models()