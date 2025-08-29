import request from "supertest";
import app from "../app";
import * as dbModule from "../db";

describe("GET /test-firestore", () => {
  it("should return ok and mocked count", async () => {
    // Firestore のモック
    const mockGet = jest.fn().mockResolvedValue({
      size: 2,
      forEach: (cb: any) => {
        cb({ id: "doc1", data: () => ({ foo: "bar" }) });
        cb({ id: "doc2", data: () => ({ foo: "baz" }) });
      },
    });

    // db.collection().get() をモック化
    jest.spyOn(dbModule.db, "collection").mockReturnValue({
      get: mockGet,
    } as any);

    const res = await request(app).get("/test-firestore");

    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: "ok", count: 2 });
    expect(mockGet).toHaveBeenCalled();
  });
});
