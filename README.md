
# **LegalSphere**

<div align="center">
  <img src="https://github.com/user-attachments/assets/b65f9cce-e94a-4a4c-8bcf-ea126bebe79b" alt="LegalSphere Logo" width="300">
  <p><strong>Empowering women to navigate the legal system with AI-powered simplicity.</strong></p>
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
5. **GROQ (RAG)**: Retrieves relevant legal information from a **JSON** database.
6. **DeepSeek**: Processes and refines legal responses.  
7. **Output**: Provides legal assistance via **text** and **voice**.

---

## **Contributors**

<table>
  <tr>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/SajeevSenthil?s=300" alt="Keerthivasan" width="150">
      <br>
      <b><a href="https://github.com/SajeevSenthil">Sajeev Senthil </a></b>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/SivaPrasanthSivaraj?s=300" alt="Siva Prasanth Sivaraj" width="150">
      <br>
      <b><a href="https://github.com/SivaPrasanthSivaraj">Siva Prasanth Sivaraj</a></b>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/suganth07?s=300" alt="Suganth" width="150">
      <br>
      <b><a href="https://github.com/suganth07">Suganth</a></b>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/Keerthivasan-Venkitajalam?s=300" alt="Keerthivasan" width="150">
      <br>
      <b><a href="https://github.com/Keerthivasan-Venkitajalam">Keerthivasan S V </a></b>
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
      <img src="https://github.com/user-attachments/assets/1528f77e-cb3b-43e6-b7ca-8032dca28d2f" alt="VQA Screen" width="300">
      <br>
      <b>Image (VQA)</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/d987ae35-1c62-4b94-84c5-36768bf4d61f" alt="Doubts Q&A Screen" width="300">
      <br>
      <b>Doubts (Q&A)</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/66e30af0-9a82-496c-b17c-3a853df684c6" alt="MultiLingual Screen" width="300">
      <br>
      <b>Multilingual Support</b>
    </td>
  </tr>
</table>

---
