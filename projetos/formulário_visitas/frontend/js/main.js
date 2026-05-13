document.getElementById("visita-form").addEventListener("submit", async function (e) {
  e.preventDefault();

  const form = document.getElementById("visita-form");
  const formData = new FormData(form);
  const statusDiv = document.getElementById("status");

  statusDiv.textContent = "Enviando...";

  try {
    const response = await fetch("http://localhost:5000/upload", {
      method: "POST",
      body: formData
    });

    const result = await response.json();

    if (response.ok) {
      statusDiv.textContent = "Sucesso: " + result.message;
      form.reset();
    } else {
      statusDiv.textContent = "Erro: " + result.error;
    }

  } catch (error) {
    statusDiv.textContent = "Falha ao enviar: " + error.message;
  }
});
