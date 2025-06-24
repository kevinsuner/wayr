const voice_name = "Mónica";
const voice_speed = 0.85;

/**
 * Text to speech using the Web Speech API.
 * @param {string} text - The content passed to the speech service.
 */
function speak(text) {
  const utterance = new SpeechSynthesisUtterance(text);
  const voices = speechSynthesis.getVoices();
  const voice_index = voices.findIndex((element) => element.name === voice_name);
  utterance.voice = voices[voice_index];
  utterance.rate = voice_speed;
  speechSynthesis.speak(utterance);
}