$(document).on("change", "#user_profile_image", function(e){
  if (e.target.files.length) {
    let reader = new FileReader;
    reader.onload = function(e) {
      $(".profile-default-img").removeClass();
      $("#profile-img").remove();
      $(".hidden").removeClass();
      $("#profile-img-prev").attr("src", e.target.result);
    };
    return reader.readAsDataURL(e.target.files[0]);
  }
});
