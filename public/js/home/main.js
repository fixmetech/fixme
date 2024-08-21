function toggleVisibility() {
    const customerContent = document.querySelector('.box-1-content');
    const technicianContent = document.querySelector('.box-1-content:last-child');
    const customerButton = document.querySelector('.item-1 .item-btn');
    const technicianButton = document.querySelector('.item-2 .item-btn');
  
    customerContent.classList.toggle('hidden');
    technicianContent.classList.toggle('hidden');
  
    customerButton.classList.toggle('active');
    technicianButton.classList.toggle('active');
  }