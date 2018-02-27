function initUpdateNavbarOnScroll() {
  const navbar = document.querySelector('.navbar-phone');
  window.addEventListener('scroll', () => {
    if (window.scrollY >= window.innerHeight) {
      console.log("hello")
      navbar.classList.add('navbar-phone-search');
    } else {
      navbar.classList.remove('navbar-phone-search');
    }
  });
}

export { initUpdateNavbarOnScroll };
