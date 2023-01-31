import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {MessagingPayload} from "firebase-admin/lib/messaging/messaging-api";
import {DocumentData} from "firebase-admin/firestore";

process.env.TZ = "Asia/Tokyo";
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
  const dateFormat = reservationData.startTime.toDate();

  const year = dateFormat.getFullYear().toString();
  const month = (dateFormat.getMonth() + 1).toString();
  const day = dateFormat.getDate().toString();
  const hour = dateFormat.getHours().toString();
  const minute = dateFormat.getMinutes().toString();

  const dateText = year + "年" + month + "月" + day + "日" + hour +"時" +minute +"分";
  return admin.messaging().sendToDevice(registrationToken, payload("salonVishu", `${dateText}に予約されました。${reservationData.treatmentDetail}`));
});


export const pushNotificationWhenDeleteReservation = functions.firestore.document("users/{userId}/reservations/{reservationId}").onDelete((snapshot)=>{
  const reservationData : DocumentData = snapshot.data();
  const registrationToken = reservationData.deviceIdList;
  const dateFormat = reservationData.startTime.toDate();

  const year = dateFormat.getFullYear().toString();
  const month = (dateFormat.getMonth() + 1).toString();
  const day = dateFormat.getDate().toString();
  const hour = dateFormat.getHours().toString();
  const minute = dateFormat.getMinutes().toString();

  const dateText = year + "年" + month + "月" + day + "日" + hour +"時" +minute +"分";
  return admin.messaging().sendToDevice(registrationToken, payload("salonVishu", `${dateText}の予約がキャンセルされました。${reservationData.treatmentDetail}`));
});

export const pushNotificationWhenOwnerMessage = functions.firestore.document("pushNotification/{pushNotificationId}").onCreate((snapshot)=>{
  const pushNotificationData : DocumentData = snapshot.data();
  const registrationTokenList = pushNotificationData.deviceIdList;

  const title = pushNotificationData.title;
  const content = pushNotificationData.content;

  return admin.messaging().sendToDevice(registrationTokenList, payload(title, content ));
});

exports.exampleSchedule = functions.pubsub.schedule("0 8 * * *").timeZone( "Asia/Tokyo").onRun(async () => {
  const d1 = new Date();
  const d2 = new Date();

  d2.setDate( d1.getDate() + 1);
  const db = admin.firestore();
  const ref = await db.collectionGroup("reservations") .where("startTime", ">", d1)
      .where("startTime", "<", d2).get();

  const deviceIdList:Array<string> = [];
  for (const reservation of ref.docs) {
    for (const deviceId of reservation.data().deviceIdList) {
      deviceIdList.push(deviceId);
    }
  }
  if (deviceIdList.length === 0) {
    return;
  }
  return admin.messaging().sendToDevice(deviceIdList, payload("予約当日になりました。", "ご来店をお待ちしております。" ));
});


class ReminderPushNotification {

  deviceIdList : Array<string>;
  treatmentDetail : string;
  startTime : any;

  constructor(deviceIdList:  Array<string>, treatmentDetail: string,startTime : string) {
    this.deviceIdList = deviceIdList;
    this.startTime = startTime;
    this.treatmentDetail = treatmentDetail;
  }
}