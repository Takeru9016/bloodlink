import { initializeApp } from "firebase-admin/app";

initializeApp();

export { onRequestCreated } from "./triggers/onRequestCreated";
export { updateRequestStatus } from "./callable/updateRequestStatus";
