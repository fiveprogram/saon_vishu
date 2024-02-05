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
      sound: "default",
    },
  };
  return message;
}

export const pushNotificationWhenCreateReservation = functions.firestore.document("users/{userId}/reservations/{reservationId}").onCreate((snapshot)=>{
  const reservationData : DocumentData = snapshot.data();
  const registrationToken = reservationData.deviceIdList;
  const dateFormat = reservationData.startTime.toDate();

  registrationToken.push(
      "fUQh6oBv60Trq0a9pVbEsr:APA91bFpsI3NgUE7x1HAXls7eYdF1mMbEgAb_-735Hsbjiascci3KnXmUpz9QByTvCZxHWFDom7S3hM5DjdCA3eLzsWxjprHA-gmh3Q9W-YdnfbBZga20MhjnCAQ3mP3shSnn3VAISlg",
      "fZ4pqZUPdkwHjHBpats8sm:APA91bGZP95G-Es3TIzn1cvhNda1Va6fS1S0SxDdEYlDxe8Oibh3pJtc4d_1yX5fereoPIUTL22ERg09GQ8gMiW5BZIACuYqUwYlH9HSTV78QGUAazYeH6Y19q8HpmGyedml7Z5npQl_",
      "fBPuuFeBTUHinRgwzGhzyB:APA91bGUxQ0QNq4JVk5RPgB-WjQmn1vxujMS6lLC4RknMXf51cBOeveODD89hK87hV0w_bGkC3ckehA76hkfPm8GB3bu3rx6xuG867lc_V2oq2tU3vE-V41f_l_V3XfBQn0X6t-WP09a",
      "fjRWDby3xkfcuPtGdrZ6av:APA91bG34herg7_dc-VSgRBzld1ckzMe2EvIRS_iQtWy0ex9juiLEbsEbMYGiuEacJUY8pbtOb9PR1m-qxzfRmNhRiaV6AgUBlV8dQUheSRgg6H1x9TKS-5LIvBcSYOQTh2TC3XLjVFh",
      "cEzU6PHtr0q-kkC3IKL5nl:APA91bHGgXbExJuxQ41zKkqUvN_38DUA8mgzECPRLu4diHmu5go3P8OjMrkcg8lmD8Q2N_lYIzCnlbq1dulVpT0fSgzOX-5q8iGLRim_NysOCC9G-uAurs6n9-XLyLm4StxKQX40LsUe",
      "efBRaKQzXkPXo4fxa-0Pq_:APA91bEToeEMFWQdmGQJDsBZe82YuOdgsmItPnzJGWTqrcaVR0gTg1H7_NXu02tR5QFvoKRQEVqoHqpwDEOah8GkgeilD2ORPfLZsg49K7bWRFqXpyqJwbYkCYIZzGhgzAAgtrw5H-mw",
  );


  console.log(registrationToken.length);
  console.log(registrationToken);
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

  registrationToken.push(
      "fUQh6oBv60Trq0a9pVbEsr:APA91bFpsI3NgUE7x1HAXls7eYdF1mMbEgAb_-735Hsbjiascci3KnXmUpz9QByTvCZxHWFDom7S3hM5DjdCA3eLzsWxjprHA-gmh3Q9W-YdnfbBZga20MhjnCAQ3mP3shSnn3VAISlg",
      "fZ4pqZUPdkwHjHBpats8sm:APA91bGZP95G-Es3TIzn1cvhNda1Va6fS1S0SxDdEYlDxe8Oibh3pJtc4d_1yX5fereoPIUTL22ERg09GQ8gMiW5BZIACuYqUwYlH9HSTV78QGUAazYeH6Y19q8HpmGyedml7Z5npQl_",
      "fBPuuFeBTUHinRgwzGhzyB:APA91bGUxQ0QNq4JVk5RPgB-WjQmn1vxujMS6lLC4RknMXf51cBOeveODD89hK87hV0w_bGkC3ckehA76hkfPm8GB3bu3rx6xuG867lc_V2oq2tU3vE-V41f_l_V3XfBQn0X6t-WP09a",
      "fjRWDby3xkfcuPtGdrZ6av:APA91bG34herg7_dc-VSgRBzld1ckzMe2EvIRS_iQtWy0ex9juiLEbsEbMYGiuEacJUY8pbtOb9PR1m-qxzfRmNhRiaV6AgUBlV8dQUheSRgg6H1x9TKS-5LIvBcSYOQTh2TC3XLjVFh",
      "cEzU6PHtr0q-kkC3IKL5nl:APA91bHGgXbExJuxQ41zKkqUvN_38DUA8mgzECPRLu4diHmu5go3P8OjMrkcg8lmD8Q2N_lYIzCnlbq1dulVpT0fSgzOX-5q8iGLRim_NysOCC9G-uAurs6n9-XLyLm4StxKQX40LsUe",
      "efBRaKQzXkPXo4fxa-0Pq_:APA91bEToeEMFWQdmGQJDsBZe82YuOdgsmItPnzJGWTqrcaVR0gTg1H7_NXu02tR5QFvoKRQEVqoHqpwDEOah8GkgeilD2ORPfLZsg49K7bWRFqXpyqJwbYkCYIZzGhgzAAgtrw5H-mw",
  );


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


exports.authDelete = functions.https.onCall( async (data, context) => {
  const contextUid = context.auth?.uid;

  await admin.auth().deleteUser(contextUid ?? "");
});
