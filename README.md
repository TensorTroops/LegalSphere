
# **LegalSphere**

<div align="center">
  <img src="https://github.com/user-attachments/assets/5b252d06-1535-4f0d-b973-807a4c590e9f" alt="LegalSphere Logo" width="300">
  <p><strong>Empowering people to navigate the legal system with AI-powered simplicity.</strong></p>
</div>

---

## **Problem Statement**

Developing an AI bot with a Voice assistant that listens to end-user questions/queries and replies back with a proper response(S2S) system. The challenge here would be that the end user can speak in any language and the bot should be able to respond in the same language. The AI bot should have a character and a back story (For example, A rude banker who hesitates to answer the query to the customer or a soft and humble actor who loves to respond to his fans) and should stick to it. The bot should answer only related to its backstory and character.

---

## **Proposed Solution**

**LegalSphere** is an **AI-powered, voice-interactive legal assistant** that simplifies legal information using **Retrieval-Augmented Generation (RAG)** technology. With the **Sarvam AI** integration, users can engage with the platform through **voice-to-voice** interaction, making legal guidance more **intuitive** and **accessible**.  

**Key Features:**
- **Voice-to-Voice Interaction**: Powered by **Sarvam AI**, users can speak their queries and receive verbal legal guidance.  
- **Multilingual Support**: Provides legal assistance in **multiple languages** to serve diverse communities.  
- **Image Analysis**: Users can upload images (e.g., legal notices or evidence) for **automated analysis** and **legal insights**.  
- **User-Friendly Interface**: Simplifies legal complexities into **easy-to-understand** responses with actionable steps.  
- **Case Filing Assistance**: Guides users through the **complaint filing process**, offering step-by-step legal support.  

---

## **Technical Implementation**

1. **Voice Input and Output (Sarvam AI)**:
   - Users interact with the system using voice.  
   - **Sarvam AI** handles **speech-to-text (STT)** and **text-to-speech (TTS)** for **real-time** bi-directional conversation.  

2. **Image Upload and Analysis**:
   - Users upload images related to harassment or legal documents.  
   - **Gemini Pro** generates a descriptive summary for analysis.  

3. **Semantic Understanding**:
   - Text input (from voice or image) is converted into **vector embeddings** using **BERT** for deeper semantic understanding.  

4. **Legal Information Retrieval**:  
   - **DeepSeek** handles knowledge retrieval using **RAG** to query a legal database and generates context-aware responses.  

5. **Guidance and Support**:
   - Connects users to the proper resources like **NGO's** and **Lawyers**. 

---

## **Work Flow**

![LegalSphere Workflow](https://github.com/user-attachments/assets/b6571952-02c0-48bc-8f58-f52cb488abc4)

---

## **Tech Stack**

### **Frontend**

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/75fd847f-a95f-4a15-8b56-2c7a50ab3a24" alt="Flutter Logo" width="150">
      <br>
      <b>Flutter</b>
    </td>
  </tr>
</table>

Built using **Flutter** and **Dart** for a **cross-platform** and **user-friendly** experience.

---

### **AI Models**

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/2de43c25-799b-44f7-a04c-8009e3aa8c34" alt="Gemini VQA Logo" width="150">
      <br>
      <b>Gemini VQA</b>
      <br>
      Visual Question Answering (VQA) for image interpretation
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/9d3b5f7d-a4c4-4cf9-9fe2-a6216f6a1312" alt="Sarvam AI Logo" width="150">
      <br>
      <b>Sarvam AI</b>
      <br>
      Real-time voice input/output (STT & TTS)
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/97cb40c0-2695-4fb8-9deb-7eda82d0aa96" alt="DeepSeek Logo" width="150">
      <br>
      <b>DeepSeek</b>
      <br>
      Advanced deep learning techniques for knowledge retrieval and synthesis
    </td>
        <td align="center">
      <img src="https://github.com/user-attachments/assets/c2433058-4167-4d7c-8589-b898559ef0c9" alt="DeepSeek Logo" width="150">
      <br>
      <b>Google Translate</b>
      <br>
      Google Translate for seamless translation from native languages to english
    </td>
  </tr>
</table>

---

## **Architecture**

1. **User Input**: Accepts **voice**, **text**, and **images**.
2. **Sarvam AI**: Converts **speech-to-text (STT)** and **text-to-speech (TTS)** for interaction.
3. **Gemini Pro**: Analyzes images for legal context.
4. **BERT**: Generates embeddings from text input for deep semantic understanding.
5. **DeepSeek**: Retrieves relevant legal information from a **JSON** database, Processes and refines legal responses.  
6. **Output**: Provides legal assistance via **text** and **voice**.

---

## **Contributors**

<table>
  <tr>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/SajeevSenthil?s=300" width="100" alt="Sajeev Senthil" /><br/>
      <a href="https://github.com/SajeevSenthil"><b>Sajeev Senthil</b></a>
    </td>
        <td align="center">
      <img src="https://avatars.githubusercontent.com/Charuvarthan?s=300" width="100" alt="Charuvarthan" /><br/>
      <a href="https://github.com/Charuvarthan-T"><b>Charuvarthan</b></a>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/suganth07?s=300" width="100" alt="Suganth" /><br/>
      <a href="https://github.com/suganth07"><b>Suganth</b></a>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/abiruth29?s=300" width="100" alt="Abiruth" /><br/>
      <a href="https://github.com/abiruth29"><b>Abiruth</b></a>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/SivaPrasanthSivaraj?s=300" width="100" alt="Siva Prasanth Sivaraj" /><br/>
      <a href="https://github.com/SivaPrasanthSivaraj"><b>Siva Prasanth Sivaraj</b></a>
    </td>
  </tr>
</table>

---

## **Challenges Faced**

- Integrating **Sarvam AI** for seamless voice-based legal assistance.  
- Ensuring **real-time** speech-to-text and text-to-speech accuracy.  
- Managing **secure API** communications for sensitive legal queries.  

---

## **Screen Grab**

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/877be5c1-812e-4381-8db8-62f7be9b3536" alt="Multilingual Screen" width="300">
      <br>
      <b>Multilingual Screen</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/faafcdb9-06f4-4d92-ac86-60aea95badae" alt="VQA" width="300">
      <br>
      <b>VQA</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/dfee1d7e-43ff-46fb-b21b-7ab775896691" alt="Voice" width="300">
      <br>
      <b>Voice Assisstant</b>
    </td>
  </tr>
</table>

---



# 🏅 Achievement

## 3rd Prize Winner – GenderTech × GenAI Hackathon
Recognized for innovation in inclusive AI design and multimodal tech solutions.
- 👥 500+ teams participated across diverse domains
- 🚀 Our team made it to the Top 10 finalists
- 🥉 Secured 3rd place overall, standing out for our agentic AI approach and impact-driven execution
