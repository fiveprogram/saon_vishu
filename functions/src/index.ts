import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {MessagingPayload} from "firebase-admin/lib/messaging/messaging-api";

admin.initializeApp();

export const sendNotification = functions.https.onRequest(() => {
  const registrationToken = "cHavfRDsRYGzefuusHbUSL:APA91bFReRvDilEq3fMS8AYbG_Kb6LTGvPliK_IXNdNbAksF8nyaavYzAUJ65RFoIz5xmR9qLwywVTcxOnBEooMpllQ1QILyDgL-c1LmgbLSIWawj25ypgy-9lYDiIkMCJ7-vqQhYMZq";

  function payload(content: string, M: string):MessagingPayload {
    const message = {
      notification: {
        title: content,
        body: M,
      },
    };
    return message;
  }

  console.log(payload);

  admin.messaging().sendToDevice(registrationToken, payload("うんち", "おしっこ"));
});


