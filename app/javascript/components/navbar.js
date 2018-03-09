function initUpdateNavbarOnScroll() {
  const navbar = document.querySelector('.navbar-phone');

  if (navbar) {
    window.addEventListener('scroll', () => {
      if (window.scrollY >= window.innerHeight) {
        navbar.classList.add('navbar-phone-search');
      } else {
        navbar.classList.remove('navbar-phone-search');
      }
    });
  }
}

export { initUpdateNavbarOnScroll };
