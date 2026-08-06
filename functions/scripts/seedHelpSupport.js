/**
 * One-off seed script for `helpFaqs` and `appConfig/support` (4B-6).
 *
 * Both collections are admin-editable in the app (Manage help & support,
 * lib/features/admin/manage_help_support) — this script only seeds initial
 * content so the Help & support screen isn't empty on first use. Re-running
 * it overwrites the same deterministic-id docs rather than duplicating them.
 *
 * Targets the real `bloodlink-dev-wt` project directly via Application
 * Default Credentials, same pattern as setAdminClaims.js — there is no
 * emulator-only mode here since this is meant to seed real, visible content.
 *
 * Usage:
 *   cd functions
 *   node scripts/seedHelpSupport.js
 */

const { initializeApp, applicationDefault } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

const PROJECT_ID = "bloodlink-dev-wt";
const SEED_ADMIN_UID = "seed-script";

initializeApp({ credential: applicationDefault(), projectId: PROJECT_ID });
const db = getFirestore();

const faqs = [
  {
    id: "how-does-matching-work",
    question: "How does blood request matching work?",
    displayOrder: 1,
    answer:
      "When a requester submits a blood request, the app matches it against " +
      "real-time stock at partnered blood banks near the request location " +
      "and shows the requester a ranked list of banks to contact. Requests " +
      "are never sent directly to an individual donor — every match routes " +
      "through a verified partner bank.",
  },
  {
    id: "how-do-donor-notifications-work",
    question: "How do donor notifications work?",
    displayOrder: 2,
    answer:
      "If you've opted in as a donor, you can get notified when a blood " +
      "request near you matches your blood group. You control how far " +
      "\"near you\" means (or turn it off entirely) from Settings. " +
      "Notifications never ask you to respond directly to a request — " +
      "they point you to a nearby bank.",
  },
  {
    id: "why-verify-as-a-donor",
    question: "Why do I need to verify my donor profile?",
    displayOrder: 3,
    answer:
      "Donor verification (ID review) is what lets you appear in the " +
      "public Donor directory — unverified donors are never shown there, " +
      "as a trust & safety measure. Verification only confirms your " +
      "identity, not your medical eligibility to donate; that's always " +
      "decided in person at the blood bank.",
  },
  {
    id: "how-do-i-update-my-info",
    question: "How do I update my blood group or contact info?",
    displayOrder: 4,
    answer:
      "Go to Profile > Settings to update your name and phone number. " +
      "Blood group and other donor details are set during donor profile " +
      "setup — reach out to support if you need to correct your blood " +
      "group after the fact.",
  },
  {
    id: "app-name-placeholder",
    question: 'Why does the app say "bloodlink"?',
    displayOrder: 5,
    answer:
      '"bloodlink" is a placeholder name while the final branding is ' +
      "confirmed — it isn't final, and will change app-wide once the " +
      "client signs off on a name.",
  },
];

const supportEmail = "support@bloodlink.app";

async function seed() {
  const batch = db.batch();
  const now = FieldValue.serverTimestamp();

  for (const faq of faqs) {
    const ref = db.collection("helpFaqs").doc(faq.id);
    batch.set(ref, {
      question: faq.question,
      answer: faq.answer,
      displayOrder: faq.displayOrder,
      updatedBy: SEED_ADMIN_UID,
      updatedAt: now,
    });
  }

  const supportRef = db.collection("appConfig").doc("support");
  batch.set(supportRef, {
    email: supportEmail,
    updatedBy: SEED_ADMIN_UID,
    updatedAt: now,
  });

  await batch.commit();
  console.log(`Seeded ${faqs.length} help FAQs and the support contact doc.`);
}

seed()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Seeding failed:", error);
    process.exit(1);
  });
