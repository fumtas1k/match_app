$(document).on("turbolinks:load", function() {
  if(location.pathname === "/users") {
    let allCards = $(".swipe--card");
    let swipeContainer = $(".swipe")[0];

    // カードを配置するメソッド
    let initCards = () => {
      let newCards = $(".swipe--card:not(.removed)");
      newCards.each(function(index, card) {
        card.style.zIndex = allCards.length - index;
        card.style.transform = `scale(${(20 - index) / 20})translateY(${- 30 * index}px)`;
        card.style.opacity = (10 - index) / 10;
      });
      if (newCards.length === 0) {
        $(".no-user").addClass("is-active");
      }
    }

    // reactionのstatusを送信するメソッド
    let postReaction = (user_id, status) => {
      $.ajax({
        url: "reactions.json",
        type: "POST",
        datatype: "json",
        data: {
          user_id: user_id,
          status: status,
        }
      });
    }

    // ハートorXボタンクリックによるイベントメソッド
    let createButtonListener = (status) => {
      let cards = $(".swipe--card:not(.removed)");
      if (!cards.length) return false;
      let moveOutWidth = document.body.clientWidth * 2;

      let card = cards[0];

      postReaction(card.id, status);
      card.classList.add("removed");

      let pos = (status === "like" ? ["", "-"] : ["-", ""]);
      card.style.transform = `translate(${pos[0] + moveOutWidth}px, -100px) rotate(${pos[1]}30deg)`;

      initCards();
    }

    // スタート
    initCards();

    $("#like").on("click", function(){
      createButtonListener("like");
    });
    $("#dislike").on("click", function(){
      createButtonListener("dislike");
    });

    allCards.each(function(_, card) {
      let hammertime = new Hammer(card);

      hammertime.on("pan", function(event){
        if (event.deltaX === 0) return;
        if (event.center.x === 0 && event.center.y === 0) return;

        card.classList.add("moving");

        swipeContainer.classList.toggle("swipe_like", event.deltaX > 0);
        swipeContainer.classList.toggle("swipe_dislike", event.deltaX < 0);

        let xMulti = event.deltaX * 0.03;
        let yMulti = event.deltaY / 80;
        let rotate = xMulti * yMulti;

        event.target.style.transform = `translate(${event.deltaX}px, ${event.deltaY}px) rotate(${rotate}deg)`;
      });

      hammertime.on("panend", function(event){
        card.classList.remove("moving");
        swipeContainer.classList.remove("swipe_like");
        swipeContainer.classList.remove("swipe_dislike");

        let moveOutWidth = document.body.clientWidth;

        let keep = Math.abs(event.deltaX) < 200;
        event.target.classList.toggle("removed", !keep);

        let status = event.deltaX > 0 ? "like" : "dislike";

        if (keep) {
          event.target.style.transform = "";
        } else {
          let endX = Math.max(Math.abs(event.velocityX) * moveOutWidth, moveOutWidth) + 100;
          let toX = event.deltaX > 0 ? endX : - endX;
          let endY = Math.abs(event.velocityY) * moveOutWidth;
          let toY = event.deltaY > 0 ? endY : - endY;
          let xMulti = event.deltaX * 0.03;
          let yMulti = event.deltaY / 80;
          let rotate = xMulti * yMulti;

          postReaction(card.id, status);

          event.target.style.transform = `translate(${toX}px, ${toY + event.deltaY}px) rotate(${rotate}deg)`;

          initCards();
        }
      });
    });
  }
});
