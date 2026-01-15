from openai import OpenAI

vllm_port = 2337

openai = OpenAI(
    base_url=f"http://127.0.0.1:{vllm_port}/v1", 
    api_key="NONONO",
)

def ask_question(question: str, json_format: bool = False, model_name: str = "gemma3-27b") -> str:
    """
    Ask a general question using a language model.
    
    Args:
        question: Question to ask
        json_format: Whether to request JSON formatted response
        model_name: Name of the language model to use
    Returns:
        Model response as string
    """
    
    
    chat_response = openai.chat.completions.create(
        model=model_name,
        messages=[
            {"role": "user", "content": [
                {"type": "text", "text": question}
            ]}
        ],
    )
    chat_response_text = chat_response.choices[0].message.content
    if not json_format:
        if "</think>" in chat_response_text:
            return chat_response_text.split("</think>")[-1].strip()
        return chat_response_text
    else:
        json_text = chat_response_text

        # 如果有一行以```开头，则默认不在json文本内，否则默认在json文本内
        in_json = not any(line.startswith("```") for line in json_text.splitlines())
        json_lines = []
        for lines in json_text.splitlines():
            if in_json and not lines.startswith("```"):
                json_lines.append(lines)
            if lines.startswith("```"):
                in_json = not in_json
        json_text = "\n".join(json_lines)
        think_end = json_text.find("</think>")
        if think_end != -1:
            json_text = json_text[think_end + len("</think>") :]
        start_idx = json_text.find("{")
        end_idx = json_text.rfind("}")
        json_text = json_text[start_idx:end_idx+1]
        print(json_text)
        return json_text