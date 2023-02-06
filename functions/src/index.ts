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
  const minute = dateFormat.getMinutes().toString().padStart(2, "0");

  const dateText = year + "年" + month + "月" + day + "日" + hour +"時" +minute +"分";
  return admin.messaging().sendToDevice(registrationToken, payload("salonVishu", `${dateText}~に予約されました。${reservationData.treatmentDetail}`));
});


export const pushNotificationWhenDeleteReservation = functions.firestore.document("users/{userId}/reservations/{reservationId}").onDelete((snapshot)=>{
  const reservationData : DocumentData = snapshot.data();
  const registrationToken = reservationData.deviceIdList;
  const dateFormat = reservationData.startTime.toDate();

  const year = dateFormat.getFullYear().toString();
  const month = (dateFormat.getMonth() + 1).toString();
  const day = dateFormat.getDate().toString();
  const hour = dateFormat.getHours().toString();
  const minute = dateFormat.getMinutes().toString().padStart(2, "0");

  const dateText = year + "年" + month + "月" + day + "日" + hour +"時" +minute +"分";
  return admin.messaging().sendToDevice(registrationToken, payload("salonVishu", `${dateText}~の予約がキャンセルされました。${reservationData.treatmentDetail}`));
});

export const pushNotificationWhenOwnerMessage = functions.firestore.document("pushNotification/{pushNotificationId}").onCreate((snapshot)=>{
  const pushNotificationData : DocumentData = snapshot.data();
  const registrationTokenList = pushNotificationData.deviceIdList;

  const title = pushNotificationData.title;
  const content = pushNotificationData.content;

  return admin.messaging().sendToDevice(registrationTokenList, payload(title, content ));
});

exports.scheduleNotification = functions.pubsub.schedule("0 8 * * *").timeZone( "Asia/Tokyo").onRun(async () => {
  const d1 = new Date();
  const d2 = new Date();

  d2.setDate( d1.getDate() + 1);
  const db = admin.firestore();
  const ref = await db.collectionGroup("reservations") .where("startTime", ">", d1)
      .where("startTime", "<", d2).get();

  if (ref.docs.length === 0) {
    return;
  }
  const reminderPushNotificationList :Array<ReminderPushNotification> = [];
  console.log(`${reminderPushNotificationList.length}クラスのリストの長さ`);

  for (const reservation of ref.docs) {
    const dateFormat = reservation.data().startTime.toDate();

    const year = dateFormat.getFullYear().toString();
    const month = (dateFormat.getMonth() + 1).toString();
    const day = dateFormat.getDate().toString();
    const hour = dateFormat.getHours().toString();
    const minute = dateFormat.getMinutes().toString().padStart(2, "0");

    const dateText = year + "年" + month + "月" + day + "日" + hour +"時" +minute +"分";

    reminderPushNotificationList.push(new ReminderPushNotification(reservation.data().deviceIdList, reservation.data().treatmentDetail, dateText));
    console.log(`${reminderPushNotificationList.length}クラスのリストの長さ`);
  }

  for (const reminderPushNotification of reminderPushNotificationList) {
    console.log("プッシュ通知送信メソッド");

    admin.messaging().sendToDevice( reminderPushNotification.deviceIdList, payload("予約当日になりました。", `${reminderPushNotification.startTime}~よりお待ちしております。${reminderPushNotification.treatmentDetail}` ));
  }
});

class ReminderPushNotification {
  deviceIdList : Array<string>;
  treatmentDetail : string;
  startTime : string;

  constructor(deviceIdList: Array<string>, treatmentDetail: string, startTime : string) {
    this.deviceIdList = deviceIdList;
    this.startTime = startTime;
    this.treatmentDetail = treatmentDetail;
  }
}


exports.automaticDelete = functions.pubsub.schedule("* * 1 * *").timeZone( "Asia/Tokyo").onRun(async () => {
  const d1 = new Date();
  const db = admin.firestore();

  const removeRestList = await db.collectionGroup("rests") .where("startTime", "<", d1).get();

  for (const remove of removeRestList.docs) {
    const restId = remove.data().restId;
    await db.collection("rests").doc(restId).delete();
  }

  const d2 = new Date();
  d2.setDate( d1.getDate() - 365);

  const removeReservationList = await db.collectionGroup("reservations") .where("startTime", "<", d2).get();

  for (const remove of removeReservationList.docs) {
    const ref = remove.ref;
    await ref.delete();
  }
});
