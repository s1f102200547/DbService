import express from "express";
import { db } from "./db";

const app = express();

app.get("/", (req, res) => {
  res.send("hello haruto");
});

// Firestore のテストエンドポイント
app.get("/test-firestore", async (req, res) => {
  try {
    const snapshot = await db.collection("reservations").get();
    snapshot.forEach(doc => {
      console.log(doc.id, "=>", doc.data()); // Cloud Run のログに出力
    });

    res.json({
      status: "ok",
      count: snapshot.size,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Firestore access failed" });
  }
});

export default app;

//test