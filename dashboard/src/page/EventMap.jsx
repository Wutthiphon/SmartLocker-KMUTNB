import { useEffect, useState } from "react";
import { FaChair } from "react-icons/fa";
import Navbar from "../components/NavbarAdmin";
import Foot from "../components/Foot";
import Swal from "sweetalert2";

export default function EventMap() {
  const [seats, setSeats] = useState([]);
  const [loading, setLoading] = useState(false);
  const [checkedIn, setCheckedIn] = useState({});
  const [search, setSearch] = useState("");
  const open = true;

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        Swal.fire({
          title: "กำลังโหลดข้อมูล",
          didOpen: () => Swal.showLoading(),
          allowOutsideClick: false,
        });

        const response = await fetch("https://api-esan.onrender.com/api/eventmap", {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        });

        if (!response.ok) {
          throw new Error(`HTTP Error: ${response.status}`);
        }

        const data = await response.json();

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
  

  const handleCheckIn = async (seat_number) => {
    if(!seat_number){
      return Swal.fire({
        icon: "warning",
        title: "กรุณากรอกหมายเลขที่นั่ง",
      });
    }
     try {
       Swal.fire({
          title: "กำลังบันทึกข้อมูล",
          didOpen: () => Swal.showLoading(),
          allowOutsideClick: false,
        });

        const response = await fetch("https://api-esan.onrender.com/api/eventmap/checkin", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            seat_number,
          }),
        });

       const data = await response.json();
       if(response.ok){
         Swal.fire({
            icon: "success",
            title: "บันทึกข้อมูลสำเร็จ",
            text: data.message,
          });
            
            setSearch("");
            window.location.reload();

        } else {
          if(response.status === 404){
            Swal.fire({
              icon: "error",
              title: "ไม่พบข้อมูลการจอง",
              text: data.message,
            });

          } else {
            Swal.fire({
              icon: "error",
              title: "เกิดข้อผิดพลาด",
              text: data.message,
            });
          }
        }
      }
      catch (error) {
        Swal.fire({
          icon: "error",
          title: "เกิดข้อผิดพลาด",
          text: error.message || "ไม่สามารถบันทึกข้อมูลได้",
        });
      }
  }

  return (
    <>
      <Navbar />

      <div className="flex flex-col items-center bg-neutral-200 min-h-screen p-6 sm:p-6 py-6">
      <div className="mt-8">
      <div className="bg-white rounded-lg shadow-md p-6 mt-8">
          <h2 className="text-xl sm:text-2xl font-bold mb-4 sm:mb-6 text-center"> 
          Check In  การเข้าร่วมงาน
          </h2>
          <div className="flex flex-col items-center">
            <div className="flex flex-col sm:flex-row items-center justify-center mb-4 sm:mb-6">
              <label htmlFor="search" className="text-lg sm:text-xl font-semibold mr-2">
                ค้นหา:
              </label>
              <input
                type="text"
                id="search"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="border border-gray-300 rounded-lg p-2 w-full sm:w-96"
                placeholder="หมายเลขที่นั่ง"
              />
            </div>
            {open == true ? (
              <button
                className="bg-orange-800 text-white px-4 py-2 sm:px-6 sm:py-3 rounded-lg text-lg sm:text-xl font-semibold"
                onClick={() => handleCheckIn(search)}
              >
                ค้นหา
              </button>
            ) : (
              <p className="text-red-500 text-xl">ยังไม่เปิดระบบ Check In </p>
            )}

            </div>
            </div>
            </div>
          

          
       

        <div className="mt-8">
          <div className="bg-white rounded-lg shadow-md p-6">
            <h1 className="text-2xl sm:text-4xl font-bold mb-4 sm:mb-6 text-center">
              แผนผังงาน
            </h1>
            <div className="bg-orange-800 text-white px-4 sm:px-8 py-2 sm:py-3 rounded-lg mb-4 sm:mb-6 text-base sm:text-lg font-semibold text-center">
              บริเวณเวที ทำการเเสดง
            </div>
            <div className="flex flex-col items-end mb-4 sm:mb-6">
              <span className="text-lg sm:text-xl font-semibold mb-2 sm:mb-4">
                 วันที่ 22 กุมพาพันธ์ 2568
              </span>
              </div>



            {loading ? (
              <div className="flex justify-center items-center">
                <div className="spinner-border text-primary" role="status">
                  <span className="sr-only">Loading...</span>
                </div>
              </div>
            ) : (
              <div className="grid gap-2 sm:gap-5 grid-cols-4 sm:grid-cols-7">
                {seats.map((seat) => (
                <div
                key={seat.seat_id}
                className={`bg-white shadow-lg p-3 sm:p-4 rounded-lg w-16 h-16 sm:w-24 sm:h-24 flex flex-col items-center justify-center text-black font-bold border border-gray-300 ${
                  seat.check_in === "1" ? "bg-green-100" : "bg-red-100"
                }`}
              >
                    <FaChair className="text-lg sm:text-2xl mb-1" />
                    <span>{seat.seat_number}</span>
                    <span>
                      {seat.check_in === "1" ? (
                        <span className="text-green-500 text-xs">Check In</span>
                      ) : (
                        <span className="text-red-600 text-xs">ยังไม่มา</span>
                      )}
                    </span>
                  </div>
                ))}
              </div>
            )}
          </div>

           

              
              

            
        </div>
        <Foot />
      </div>
    </>
  );
}
