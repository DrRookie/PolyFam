class Chat {
  final String name, lastMessage, image, time;
  final bool isActive;

  Chat({
    this.name = '',
    this.lastMessage = '',
    this.image = '',
    this.time = '',
    this.isActive = false,
  });
}

List chatsData = [

Chat(
name: "Jenny Wilson",
lastMessage: "Hope you are doing well...",
image: "images/userOne.jpeg",
time: "3m ago",
isActive: false,
),
Chat(
name: "Esther Howard",
lastMessage: "Hello Abdullah! I am...",
image: "images/user_2.png",
time: "8m ago",
isActive: true,
),];
