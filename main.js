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
 * Displays the value of `#duration-range` slider.
 */
function set_duration() {
  document.getElementById("duration").innerHTML = document.getElementById("duration-range").value;
}

/**
 * Displays the value of `#interval-range` slider.
 */
function set_interval() {
  document.getElementById("interval").innerHTML = document.getElementById("interval-range").value;
}

/**
 * Triggers `speak` recurrently informing about the finished interval and the
 * remaining duration.
 */
function start() {
  let duration = document.getElementById("duration-range").value;
  let interval = document.getElementById("interval-range").value;
  const now = new Date();
  const end = new Date(now.getTime() + duration * 60000); // N minutes * 60 seconds * 1000 miliseconds
  
  setInterval(() => {
    if (now.getTime() < end) {
      duration -= interval;
      speak(`Intervalo de ${interval} minutos completado, ${duration} minutos restantes`);
    }
  }, interval * 60000);
}
