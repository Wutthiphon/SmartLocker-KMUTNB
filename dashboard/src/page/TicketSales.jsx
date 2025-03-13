import React, { useEffect, useState } from 'react'; 
import Navbar from "../components/NavbarAdmin";
import axios from "axios";
import { IoTicketOutline } from "react-icons/io5";
import Swal from "sweetalert2";
import Foot from "../components/Foot";

const TicketSales = () => {
   const [seat, setSeat] = useState([]);
   const [filteredSeats, setFilteredSeats] = useState([]);
   const [selectedZone, setSelectedZone] = useState("");
   const [isLoading_2, setIsLoading_2] = useState(false);


   useEffect(() => {
      let isMounted = true;
      const fetchData = async () => {
          setIsLoading_2(true);
  
          let swalLoading = Swal.fire({
              title: "กำลังโหลด...",
              allowOutsideClick: false,
              didOpen: () => {
                  Swal.showLoading();
              },
          });
  
          try {
              const res = await axios.get("https://52.62.242.78/api/all/seat");
              if (!res.data || !Array.isArray(res.data)) {
                  throw new Error("ข้อมูลที่ได้รับไม่ถูกต้อง");
              }
  
              const filterSeat = res.data.filter(item => item.seat_status === "Available")
                  .sort((a, b) => a.seat_number.localeCompare(b.seat_number, "en", { numeric: true }));

              if (isMounted) {
                  setSeat(filterSeat);
                  setFilteredSeats(filterSeat);
                  swalLoading.close();
                  Swal.fire({
                      icon: "success",
                      title: "โหลดข้อมูลสำเร็จ!",
                      showConfirmButton: false,
                      timer: 1000,
                  });
              }
          } catch (error) {
              console.error("เกิดข้อผิดพลาด:", error);
              if (isMounted) {
                  swalLoading.close();
                  Swal.fire({
                      icon: "error",
                      title: "เกิดข้อผิดพลาด",
                      text: "ไม่สามารถโหลดข้อมูลที่นั่งได้",
                  });
              }
          } finally {
              if (isMounted) setIsLoading_2(false);
          }
      };
  
      fetchData();
  
      return () => {
          isMounted = false; 
      };
  }, []);

  const handleZoneChange = (event) => {
    const zone = event.target.value;
    setSelectedZone(zone);

    if (zone) {
      setFilteredSeats(seat.filter(item => item.seat_type === zone && item.seat_status === "Available"));
    } else {
      setFilteredSeats(seat);
    }
  };


  const handleBooking = async (seat_number) => {
   try {
       // Show loading Swal while fetching the QR code
       Swal.fire({
           title: "กำลังโหลด",
           allowOutsideClick: false,
           didOpen: () => Swal.showLoading(),
       });

       // Fetch the QR code image
       const res = await axios.get(`https://52.62.242.78/api/QRcode`, { responseType: "text" });

       if (!res.data) {
           throw new Error("ไม่สามารถจองที่นั่งได้");
       }

       // Assuming the QR code is base64 encoded, set it as the image source
       const imageUrl = res.data; // Base64 encoded QR code

       // Show the payment modal with the QR code and seat information
       Swal.fire({
           title: "ชำระเงิน",
           html: `
               <p>คุณได้เลือกที่นั่งหมายเลข: <strong>${seat_number}</strong></p>
               <img src="${imageUrl}" alt="QR Code" class="w-64 h-64 mx-auto" />
               <p>กรุณาชำระเงินภายใน 15 นาที</p>
           `,
           showCancelButton: true,
           confirmButtonText: "ยืนยันการชำระเงิน",
           cancelButtonText: "ยกเลิก",
       }).then((result) => {
           if (result.isConfirmed) {
             const radom = Math.floor(Math.random() * 10000000000000000000000000);
               const data = {
                   first_name: "ผู้ดูแลระบบ",
                   last_name: "-",
                   phone: "0987577501",
                   status: "Paid",
                   email: radom + "@kmutnb.ac.th",
                   seatId: seat_number,
                   URL: "-",
                   university: "kmutnb",
               };

               // Send seat booking data to the server
               axios.post("https://52.62.242.78/api/create/seat", data)
                   .then((res) => {
                       if (res) {
                           Swal.fire({
                               icon: "success",
                               title: "ชำระเงินสำเร็จ",
                               text: "คุณได้จองที่นั่งเรียบร้อยแล้ว!",
                           });
                       }
                   })
                   .catch((error) => {
                       console.error("Error sending seat booking data:", error);
                       Swal.fire({
                           icon: "error",
                           title: "ไม่สามารถบันทึกข้อมูลการจอง",
                           text: "เกิดข้อผิดพลาดในการบันทึกข้อมูลการจองที่นั่ง",
                       });
                   });
           } else {
               Swal.fire({
                   icon: "info",
                   title: "ยกเลิกการจอง",
                   text: "คุณยกเลิกการชำระเงิน",
               });
           }
       });
   } catch (error) {
       console.error("Error:", error);
       Swal.fire({
           icon: "error",
           title: "เกิดข้อผิดพลาด",
           text: "ไม่สามารถสร้าง QR code ได้",
       });
   }
};






     
   


  
  return (
   <>
      <Navbar />
  <div  className='bg-neutral-200 min-h-screen'>
      <div className="container mx-auto p-6 ">
         <h1 className="text-3xl font-bold mb-4 text-center">จำหน่ายบัตร</h1>
         
         <div className="mb-4 text-center">
            <label className="mr-4">เลือกโซน:</label>
            <select 
              value={selectedZone} 
              onChange={handleZoneChange} 
              className="border p-2 rounded"
            >
               <option value="">ทั้งหมด</option>
               <option value="A">โซน A</option>
               <option value="B">โซน B</option>
               <option value="C">โซน C</option>
               <option value="D">โซน D</option>
               <option value="E">โซน E</option>
            </select>
         </div>

         <div className="flex justify-center ">
            <div className="grid grid-cols-4 gap-4 mt-6">
               {filteredSeats.map((item) => (
                  <div key={item.id}>
                     <div className="flex items-center justify-center">
                        <div className="bg-white border border-gray-200 rounded-lg shadow-sm p-4 w-64">
                           <div className="flex justify-center">
                              <IoTicketOutline className="text-4xl text-orange-800" />
                           </div>
                           <div className="text-center mt-6 mb-4">
                              <h4 className="text-lg font-semibold text-gray-800">
                                 หมายเลขที่นั่ง {item.seat_number}
                              </h4>
                              <p className="text-sm text-gray-500">
                                 ราคาบัตร 1000 บาท
                              </p>
                           </div>
                           <div className="flex justify-center">
                              <button
                                 value={item.seat_number}
                                 onClick={() => handleBooking(item.seat_number)}
                                 className="bg-gradient-to-r from-orange-800 to-orange-700 text-white font-bold py-2 px-4 rounded"
                              >
                                 จองที่นั่ง
                              </button>
                           </div>
                        </div>
                     </div>
                  </div>
               ))}
            </div>
         </div>
         <Foot />
      </div>
      </div>
   </>
  );
};

export default TicketSales;


