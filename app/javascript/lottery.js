document.addEventListener("DOMContentLoaded", () => {
    const decreaseBtn = document.getElementById("decrease");
    const increaseBtn = document.getElementById("increase");
    const quantityInput = document.getElementById("ticket-quantity");
    const hiddenInput = document.getElementById("ticket-quantity-input");

    if (decreaseBtn && increaseBtn && quantityInput && hiddenInput) {
        decreaseBtn.addEventListener("click", (e) => {
            e.preventDefault();
            if (quantityInput.value > 0) {
                quantityInput.value = parseInt(quantityInput.value) - 1;
                hiddenInput.value = quantityInput.value;
            }
        });

        increaseBtn.addEventListener("click", (e) => {
            e.preventDefault();
            quantityInput.value = parseInt(quantityInput.value) + 1;
            hiddenInput.value = quantityInput.value;
        });
    }
});