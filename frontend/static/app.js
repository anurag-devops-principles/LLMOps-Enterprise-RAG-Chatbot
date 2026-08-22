const form = document.querySelector("#chat-form");
const input = document.querySelector("#query");
const sendButton = document.querySelector("#send-button");
const chatWindow = document.querySelector("#chat-window");
const statusBadge = document.querySelector("#status");

function setStatus(label, className) {
  statusBadge.className = `status ${className}`;
  statusBadge.lastChild.textContent = ` ${label}`;
}

function addMessage(role, text) {
  const message = document.createElement("article");
  message.className = `message ${role}`;

  const avatar = document.createElement("div");
  avatar.className = "avatar";
  avatar.textContent = role === "user" ? "You" : "AI";

  const bubble = document.createElement("div");
  bubble.className = "bubble";
  bubble.textContent = text;

  message.append(avatar, bubble);
  chatWindow.append(message);
  chatWindow.scrollTop = chatWindow.scrollHeight;

  return bubble;
}

async function checkHealth() {
  try {
    const response = await fetch("/health");
    if (!response.ok) {
      throw new Error("Health check failed");
    }
    setStatus("Online", "online");
  } catch {
    setStatus("Offline", "error");
  }
}

form.addEventListener("submit", async (event) => {
  event.preventDefault();

  const query = input.value.trim();
  if (!query) {
    return;
  }

  addMessage("user", query);
  input.value = "";
  input.focus();
  sendButton.disabled = true;

  const pendingBubble = addMessage("assistant", "Thinking...");

  try {
    const response = await fetch(`/chat?query=${encodeURIComponent(query)}`);
    if (!response.ok) {
      throw new Error(`Request failed with status ${response.status}`);
    }

    const data = await response.json();
    pendingBubble.textContent = data.response || "No response returned.";
  } catch (error) {
    pendingBubble.textContent = `Request failed: ${error.message}`;
  } finally {
    sendButton.disabled = false;
  }
});

input.addEventListener("keydown", (event) => {
  if (event.key === "Enter" && !event.shiftKey) {
    event.preventDefault();
    form.requestSubmit();
  }
});

checkHealth();
