import consumer from "./consumer"

const appChatRoom = consumer.subscriptions.create("ChatRoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $("#messages").append(data["message"]);
    // const messages = document.getElementById('messages');
    // messages.insertAdjacentHTML('beforeend', data['message']);
  },

  speak: function(message, chat_room_id) {
    return this.perform('speak', {message: message, chat_room_id: chat_room_id});
  }
});

if (/chat_rooms/.test(location.pathname)) {
  $(document).on("keypress", ".chat-room__message-form_textarea", function(e){
    const value = e.target.value;
    if(e.key === "Enter" && value.match(/\S/g)) {
      const chat_room_id = $("textarea").data("chat_room_id");
      appChatRoom.speak(value, chat_room_id);
      e.target.value = "";
      e.preventDefault();
    }
  });
}
