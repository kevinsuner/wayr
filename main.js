const VOICE_NAME = "Mónica";
const VOICE_SPEED = 0.85;

/**
 * Text to speech using the Web Speech API.
 * @param {string} text - The content passed to the speech service.
 */
function speak(text) {
  const utterance = new SpeechSynthesisUtterance(text);
  const voices = speechSynthesis.getVoices();
  const voice_index = voices.findIndex((element) => element.name === VOICE_NAME);
  utterance.voice = voices[voice_index];
  utterance.rate = VOICE_SPEED;
  speechSynthesis.speak(utterance);
}

/**
 * Triggers `speak` recurrently informing about the finished interval and the
 * remaining duration.
 */
function start() {
  let duration = document.getElementById("duration-input").value;
  let interval = document.getElementById("interval-input").value;
  const now = new Date();
  const end = new Date(now.getTime() + duration * 60000); // N minutes * 60 seconds * 1000 miliseconds
  
  setInterval(() => {
    if (now.getTime() < end) {
      duration -= interval;
      speak(`Intervalo de ${interval} minutos completado, ${duration} minutos restantes`);
    }
  }, interval * 60000);
}
