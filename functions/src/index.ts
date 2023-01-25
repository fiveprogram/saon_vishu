import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const sendPushNotification = functions.https.onCall(async (data) => {
  const uid = data.uid;
  const message = data.message;
  const userRef = admin.firestore().collection("users").doc(uid);
  const userSnapshot = await userRef.get();
  const user = userSnapshot.data();
  const deviceToken = user!.deviceToken;
  const payload = {
    notification: {title: "Salon vishu", body: message},
  };

  try {
    await admin.messaging().sendToDevice(deviceToken, payload);
    return {success: true};
  } catch (error) {
    return {success: false, error};
  }
});
