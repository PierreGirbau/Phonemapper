function initUpdateNavbarOnScroll() {
  const navbar = document.querySelector('.navbar-wagon');
  window.addEventListener('scroll', () => {
    if (window.scrollY >= window.innerHeight) {
      navbar.classList.add('navbar-wagon-search');
    } else {
      navbar.classList.remove('navbar-wagon-search');
    }
  });
}

export { initUpdateNavbarOnScroll };
