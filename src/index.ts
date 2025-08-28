import express from "express";
import { db } from "./db";

const app = express();

app.get("/", (req, res) => {
  res.send("Hello from db-service!");
});

// Firestore のテストエンドポイント
app.get("/test-firestore", async (req, res) => {
  try {
    const snapshot = await db.collection("reservations").get(); // 例: reservations コレクション
    snapshot.forEach(doc => {
      console.log(doc.id, "=>", doc.data());  // Cloud Run のログに表示される
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

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`DbService running on port ${PORT}`);
});
