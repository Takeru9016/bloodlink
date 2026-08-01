/**
 * One-off seed script for the `educationArticles` collection (2A-10).
 *
 * Targets the Firestore emulator only — refuses to run unless
 * FIRESTORE_EMULATOR_HOST is set, so it can never accidentally write to a
 * real project. Building the admin UI for this content is 2A-11; until then
 * this script (or the emulator UI / console) is the only way to populate it.
 *
 * Usage:
 *   firebase emulators:start --only firestore
 *   # in a second terminal:
 *   cd functions
 *   FIRESTORE_EMULATOR_HOST=localhost:8080 node scripts/seedEducationArticles.js
 */

const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

if (!process.env.FIRESTORE_EMULATOR_HOST) {
  console.error(
    "FIRESTORE_EMULATOR_HOST is not set — refusing to run against a real " +
      "Firebase project. Start the emulator and set " +
      "FIRESTORE_EMULATOR_HOST=localhost:8080 first."
  );
  process.exit(1);
}

// The emulator ignores credentials entirely, so no service account or
// application-default login is needed here.
initializeApp({ projectId: "bloodlink-dev-wt" });
const db = getFirestore();

const SEED_ADMIN_UID = "seed-script";

const articles = [
  {
    id: "what-is-blood",
    title: "What is blood?",
    category: "basics",
    displayOrder: 1,
    body:
      "Blood is the fluid that carries oxygen, nutrients, and immune " +
      "cells around your body. It's made up of four main parts: red " +
      "blood cells, which carry oxygen from your lungs to the rest of " +
      "your body; white blood cells, which help fight infection; " +
      "platelets, which help your blood clot and stop bleeding; and " +
      "plasma, the liquid that carries all of the above plus proteins " +
      "and nutrients.\n\n" +
      "When you donate blood, a blood bank can use it as whole blood or " +
      "separate it into these individual parts, so a single donation " +
      "can end up helping more than one patient — for example, someone " +
      "having surgery might need red cells, while someone with a " +
      "clotting condition might need platelets.\n\n" +
      "Your body replaces the fluid and cells lost during a donation " +
      "over the following days to weeks, which is part of why blood " +
      "banks space out how often a person can donate.",
  },
  {
    id: "blood-types-compatibility",
    title: "Blood types & compatibility — who can donate to whom",
    category: "basics",
    displayOrder: 2,
    body:
      "There are 8 common blood types, based on two things: your ABO " +
      "group (A, B, AB, or O) and your Rh factor (positive or " +
      "negative) — giving A+, A-, B+, B-, AB+, AB-, O+, and O-.\n\n" +
      "Compatibility matters because your immune system can react " +
      "badly to a blood type it doesn't recognize as its own. As a " +
      "general pattern: O- is often called a 'universal donor' because " +
      "it can typically be given to people of any blood type in an " +
      "emergency, while AB+ is often called a 'universal recipient' " +
      "because someone with AB+ can typically receive red cells from " +
      "any type. Most other combinations are more limited — for " +
      "example, someone who is A+ can generally receive from A+, A-, " +
      "O+, and O- donors.\n\n" +
      "This is a simplified summary, not a substitute for a blood " +
      "bank's own matching process — the bank always confirms " +
      "compatibility directly before using a donation, and plasma " +
      "compatibility actually runs in the opposite direction from red " +
      "cells. If you're curious about your own type, the easiest way to " +
      "find out is to ask at your first donation.",
  },
  {
    id: "who-can-donate",
    title: "Who can donate? — eligibility basics",
    category: "eligibility",
    displayOrder: 3,
    body:
      "This page is general information to help you decide whether it's " +
      "worth heading to a blood bank — it isn't a medical clearance, " +
      "and it can't tell you for certain whether you'll be able to " +
      "donate on a given day. That decision is always made in person " +
      "at the blood bank, based on a short health check and your " +
      "answers to their questions at the time.\n\n" +
      "Broadly, many blood banks look for donors who are within a " +
      "certain age range and weight range, are in generally good " +
      "health on the day of donation, and haven't recently had certain " +
      "illnesses, medical procedures, tattoos/piercings, or travel to " +
      "certain regions. Exact rules vary by blood bank and country.\n\n" +
      "If you're on medication, have a chronic condition, are pregnant " +
      "or recently were, or you're just unsure, the best next step is " +
      "to contact the blood bank directly or bring it up when you " +
      "arrive — they'll make the call, not this app. Eligibility is " +
      "also something you self-report honestly, since it protects both " +
      "you and the person who eventually receives the donation.",
  },
  {
    id: "dos-and-donts-before-donating",
    title: "Do's and don'ts before donating",
    category: "guidance",
    displayOrder: 4,
    body:
      "A few simple habits in the day or two before you donate can make " +
      "the experience easier and help your body recover faster " +
      "afterward.\n\n" +
      "Do: get a good night's sleep beforehand, eat a proper meal in " +
      "the hours before your appointment, drink extra water the day of " +
      "and before, and bring a valid ID and, if you have one, your " +
      "donor card or past donation record.\n\n" +
      "Don't: donate on an empty stomach, show up dehydrated, or " +
      "exercise heavily right before your appointment. It's also worth " +
      "mentioning to the staff if you've recently started a new " +
      "medication, felt unwell, or had a tattoo, piercing, or minor " +
      "procedure — they'll let you know if it affects timing.\n\n" +
      "This is general guidance, not a checklist that guarantees you'll " +
      "be able to donate — the blood bank's own screening on the day " +
      "always has the final say.",
  },
  {
    id: "dos-and-donts-after-donating",
    title: "Do's and don'ts after donating",
    category: "guidance",
    displayOrder: 5,
    body:
      "What you do in the hours after donating helps your body bounce " +
      "back and lowers the chance of feeling lightheaded or unwell.\n\n" +
      "Do: rest for a few minutes at the donation site before leaving, " +
      "have the snack and drink offered by the staff, keep drinking " +
      "extra fluids for the rest of the day, and keep the bandage on " +
      "for the time the staff recommend.\n\n" +
      "Don't: rush straight into strenuous exercise, heavy lifting, or " +
      "alcohol for the rest of the day, and try to avoid standing for " +
      "long periods right after donating. If you feel dizzy, " +
      "lightheaded, or unwell at any point, sit or lie down and let " +
      "someone nearby know — if symptoms don't pass quickly, contact " +
      "the blood bank or seek medical attention.\n\n" +
      "Most people feel completely normal within a day, but everyone " +
      "recovers a little differently, so go by how you actually feel " +
      "rather than a fixed schedule.",
  },
  {
    id: "faq",
    title: "Frequently asked questions",
    category: "faq",
    displayOrder: 6,
    body:
      "How long does donating blood take? Usually 30–45 minutes total, " +
      "including registration, a brief health check, the donation " +
      "itself (about 8–10 minutes), and a short rest afterward.\n\n" +
      "Does it hurt? Most people feel a quick pinch when the needle " +
      "goes in and little to nothing during the donation itself.\n\n" +
      "How often can I donate? This varies by blood bank and by what " +
      "you donate (whole blood vs. platelets, for example), since your " +
      "body needs time to replace what's taken. The blood bank you " +
      "donate at can tell you the exact interval that applies to you.\n\n" +
      "Will I find out my blood type? Many blood banks will tell you " +
      "your blood type after your first donation if you ask, though " +
      "it's not always automatic.\n\n" +
      "Can I donate if I'm not sure I'm eligible? Yes — come in and ask. " +
      "Blood banks would rather screen you in person than have you " +
      "rule yourself out based on a guess. See 'Who can donate?' for " +
      "general context, and remember only the blood bank can confirm " +
      "eligibility on the day.\n\n" +
      "What happens to my donation? It's typically tested, processed, " +
      "and — for whole blood — often separated into red cells, " +
      "plasma, and platelets so it can help more than one patient.",
  },
];

async function seed() {
  const batch = db.batch();
  const now = FieldValue.serverTimestamp();

  for (const article of articles) {
    // Deterministic (slug) ids rather than auto-ids, so re-running this
    // script overwrites the same 6 documents instead of duplicating them.
    const ref = db.collection("educationArticles").doc(article.id);
    batch.set(ref, {
      title: article.title,
      body: article.body,
      category: article.category,
      displayOrder: article.displayOrder,
      updatedBy: SEED_ADMIN_UID,
      updatedAt: now,
    });
  }

  await batch.commit();
  console.log(`Seeded ${articles.length} education articles.`);
}

seed()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Seeding failed:", error);
    process.exit(1);
  });
