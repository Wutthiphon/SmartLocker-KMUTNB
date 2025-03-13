import React, { useState, useEffect } from "react";
import Swal from "sweetalert2";
import Navbar from "../components/NavbarAdmin";
import Foot from "../components/Foot";
import { FaChair } from "react-icons/fa";

function T() {
  const [loading, setLoading] = useState(false);
  const [seats, setSeats] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        Swal.fire({
          title: "กำลังโหลดข้อมูล",
          didOpen: () => Swal.showLoading(),
          allowOutsideClick: false,
        });

        const response = await fetch("https://52.62.242.78/api/eventmap", {
          method: "GET",
          headers: { "Content-Type": "application/json" },
        });

        if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);

        const data = await response.json();

        // เรียงลำดับที่นั่ง
        data.sort((a, b) =>
          a.seat_number.localeCompare(b.seat_number, "en", { numeric: true })
        );

        setSeats(data);
        Swal.close();
      } catch (error) {
        Swal.fire({
          icon: "error",
          title: "ข้อผิดพลาด",
          text: error.message || "ไม่สามารถโหลดข้อมูลได้",
        });
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  // แยกที่นั่งตามตัวอักษร (A, B, C, ...)
  const groupedSeats = seats.reduce((acc, seat) => {
    const rowLetter = seat.seat_number.charAt(0); // ดึงตัวอักษร A, B, C
    if (!acc[rowLetter]) acc[rowLetter] = [];
    acc[rowLetter].push(seat);
    return acc;
  }, {});

  return (
    <div>
      <Navbar />
      <div className="bg-neutral-200 min-h-screen">
        <div className="py-10">
          <div className="container mx-auto px-4 sm:px-6 lg:px-10">
            <div className="bg-white p-6 rounded-lg shadow-lg">
              <div className="flex flex-col items-center">
                <img
                  src="https://iili.io/2DAMRoJ.png"
                  alt="logo"
                  className="w-72 h-72"
                />
                <div className="text-center text-lg text-orange-800 mt-4">
                  <h1 className="text-2xl font-bold mt-4">
                    ผังงานพาแลง ครั้งที่ 45
                  </h1>
                </div>
                <div className="text-center text-lg text-gray-900 mt-4">
                  งานพาแลง ครั้งที่ 45 จัดโดยชมรมอีสาน
                  มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ
                </div>
                <div className="flex flex-col items-end mb-4 sm:mb-6">
                  <span className="text-lg sm:text-xl font-semibold mb-2 sm:mb-4">
                    วันที่ 22 กุมภาพันธ์ 2568
                  </span>

                  {/* ผังเวที  */}


                

                </div>

                <div className="text-center text-lg text-gray-900 mt-4 py-4">
  <div className="bg-orange-800 text-white px-4 py-2 rounded-lg w-full">
    บริเวณเวทีทำการแสดง
  </div>
</div>



                {loading ? (
                  <div className="flex justify-center items-center">
                    <div className="spinner-border text-primary" role="status">
                      <span className="sr-only">Loading...</span>
                    </div>
                  </div>
                ) : (
                  <div className="flex gap-4">
                    {Object.keys(groupedSeats).map((row) => (
                      <div key={row} className="flex flex-col gap-2">
                        {groupedSeats[row].map((seat) => (
                          <div
                            key={seat.seat_id}
                            className={`bg-white shadow-lg p-3 sm:p-4 rounded-lg w-16 h-16 sm:w-24 sm:h-24 flex flex-col items-center justify-center text-black font-bold border border-gray-300 ${
                              seat.seat_status === "Available"
                                ? "bg-green-100"
                                : "bg-red-100"
                            }`}
                          >
                            <FaChair className="text-lg sm:text-2xl mb-1" />
                            <span>{seat.seat_number}</span>
                            <span>
                              {seat.seat_status === "approve" ? (
                                <span className="text-green-500 text-xs">
                                  ซื้อแล้ว
                                </span>
                              ) : (
                                <span className="text-red-600 text-xs">ว่าง</span>
                              )}
                            </span>
                          </div>
                        ))}
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </div>
          </div>
          <Foot />
        </div>
      </div>
    </div>
  );
}

export default T;
