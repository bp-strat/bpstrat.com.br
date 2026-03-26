document.addEventListener("DOMContentLoaded", function() {
	const nav = document.querySelector(".nav-list");
	if (!nav) return;

	nav.addEventListener("click", function(e) {
		const btn = e.target.closest(".nav-list-expander");
		if (!btn) return;

		const item = btn.closest(".nav-list-item");
		if (!item) return;

		const isOpen = item.classList.contains("active");

		// fecha siblings no mesmo nível
		const siblings = item.parentElement.children;
		for (let sibling of siblings) {
			if (sibling !== item) {
				sibling.classList.remove("active");
			}
		}

		// toggle apenas do atual
		if (isOpen) {
			item.classList.remove("active");
		} else {
			item.classList.add("active");
		}
	});
});
