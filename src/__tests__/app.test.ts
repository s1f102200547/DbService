import request from "supertest";
import app from "../app";

describe("GET /", () => {
  it("should return hello haruto", async () => {
    const res = await request(app).get("/");
    expect(res.status).toBe(200);
    expect(res.text).toBe("hello haruto");
  });
});
