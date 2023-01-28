import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {MessagingPayload} from "firebase-admin/lib/messaging/messaging-api";
import {DocumentData} from "firebase-admin/firestore";

admin.initializeApp();

function payload(title: string, content: string):MessagingPayload {
  const message = {
    notification: {
      title: title,
      body: content,
    },
  };
  return message;
}

export const pushNotificationWhenCreateReservation = functions.firestore.document("users/{userId}/reservations/{reservationId}").onCreate((snapshot)=>{
  const reservationData : DocumentData = snapshot.data();
  const registrationToken = reservationData.deviceIdList;
  process.env.TZ = "Asia/Tokyo";
  const dateFormat = reservationData.startTime.toDate();

  const year = dateFormat.getFullYear().toString();
  const month = (dateFormat.getMonth() + 1).toString();
  const day = dateFormat.getDate().toString();
  const hour = dateFormat.getHours().toString();
  const minute = dateFormat.getMinutes().toString();

  const dateText = year + "年" + month + "月" + day + "日" + hour +"時" +minute +"分";
  admin.messaging().sendToDevice(registrationToken, payload("salonVishu", `${dateText}に予約されました。${reservationData.treatmentDetail}`));
});


export const pushNotificationWhenDeleteReservation = functions.firestore.document("users/{userId}/reservations/{reservationId}").onDelete((snapshot)=>{
  const reservationData : DocumentData = snapshot.data();
  const registrationToken = reservationData.deviceIdList;
  process.env.TZ = "Asia/Tokyo";
  const dateFormat = reservationData.startTime.toDate();

  const year = dateFormat.getFullYear().toString();
  const month = (dateFormat.getMonth() + 1).toString();
  const day = dateFormat.getDate().toString();
  const hour = dateFormat.getHours().toString();
  const minute = dateFormat.getMinutes().toString();

  const dateText = year + "年" + month + "月" + day + "日" + hour +"時" +minute +"分";
  admin.messaging().sendToDevice(registrationToken, payload("salonVishu", `${dateText}の予約がキャンセルされました。${reservationData.treatmentDetail}`));
});

export const pushNotificationWhenOwnerMessage = functions.firestore.document("pushNotification/{pushNotificationId}").onCreate((snapshot)=>{
  const pushNotificationData : DocumentData = snapshot.data();
  const registrationTokenList = pushNotificationData.deviceIdList;

  const title = pushNotificationData.title;
  const content = pushNotificationData.content;

  admin.messaging().sendToDevice(registrationTokenList, payload(title, content ));
});

export const scheduleNotification = functions.firestore.document("users/{userId}/reservations/{reservationId}").onCreate((async (snapshot)=> {
  process.env.TZ = "Asia/Tokyo";
  const reservation = snapshot.data();
  const registrationTokenList = reservation.deviceIdList;

  const dateFormat = reservation.startTime.toDate();

  const year = dateFormat.getFullYear().toString();
  const month = (dateFormat.getMonth() + 1).toString();
  const day = dateFormat.getDate().toString();
  const hour = dateFormat.getHours().toString();
  const minute = dateFormat.getMinutes().toString();

  const dateText = year + "年" + month + "月" + day + "日" + hour +"時" +minute +"分";


  exports.scheduleFunction = functions.pubsub.schedule(`0,8,${day},${month},${year}`).onRun(() => {
    return admin.messaging().sendToDevice(registrationTokenList, payload("予約当日になりました。", `${dateText}/${reservation.treatmentDetail}` ));
  });
})
);
