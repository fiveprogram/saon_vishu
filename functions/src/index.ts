import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

const registrationToken = "fubrnf3FTkC77CnooZJazz:APA91bEhBpzqUXDZ-UFns3rrwgARJ-hefelmvdMG9rn86v8ateu7w_waqqQcbSzN66GU3Oi8b4gnG-tYCUsAIT8GgQnmEyfQyxjbxE_K-Vm-w4p-azsn5CnsamgGpY4lASWoztiN6XG2";
const payload = {
  notification: {
    title: "Salon vishu",
    body: "Push Notification"},
};

admin.messaging().sendToDevice(registrationToken, payload)
    .then((response) => {
      console.log("Successfully sent message:", response);
    })
    .catch((error) => {
      console.log("Error sending message:", error);
    });
