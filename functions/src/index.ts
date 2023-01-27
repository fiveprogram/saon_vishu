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
  admin.messaging().sendToDevice(registrationToken, payload("salonVishu", `${reservationData.treatmentDetail}が${dateText}に予約されました。`));
});
