/* CreaClick Agency – formulaire de contact (Web3Forms) */
(function () {
  "use strict";

  var form = document.getElementById("contact-form");
  if (!form) return;

  var status = form.querySelector(".form-status");
  var button = form.querySelector('button[type="submit"]');
  var MERCI = "/contact/merci/";

  // Pré-sélection du type d'événement depuis l'URL (ex. /contact/?objet=partenariat)
  var objet = new URLSearchParams(window.location.search).get("objet");
  if (objet === "partenariat") {
    var select = form.querySelector("#type");
    if (select) select.value = "Partenariat / sponsoring";
  }

  function showStatus(text, isError) {
    status.textContent = text;
    status.hidden = false;
    status.classList.toggle("is-error", !!isError);
  }

  form.addEventListener("submit", function (e) {
    e.preventDefault();

    if (form.access_key.value === "WEB3FORMS_ACCESS_KEY") {
      showStatus("Formulaire non configuré : clé Web3Forms manquante. Écrivez-nous à info@creaclickagency.com.", true);
      return;
    }

    var data = Object.fromEntries(new FormData(form));
    delete data.redirect; // inutile en AJAX
    data.botcheck = form.botcheck.checked;

    button.disabled = true;
    button.textContent = "Envoi en cours…";
    status.hidden = true;

    fetch(form.action, {
      method: "POST",
      headers: { "Content-Type": "application/json", Accept: "application/json" },
      body: JSON.stringify(data)
    })
      .then(function (res) { return res.json(); })
      .then(function (json) {
        if (!json.success) throw new Error(json.message || "Erreur d'envoi");
        window.location.href = MERCI;
      })
      .catch(function () {
        showStatus("L'envoi a échoué. Réessayez dans un instant, ou écrivez-nous à info@creaclickagency.com / appelez le +33 6 78 20 17 19.", true);
        button.disabled = false;
        button.textContent = "Envoyer ma demande";
      });
  });
})();
