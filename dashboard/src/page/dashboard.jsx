import React, { useEffect, useState } from "react";
import Navbar from "../components/NavbarAdmin";
import Swal from "sweetalert2";
import Cookies from "js-cookie";
import { TfiMoney } from "react-icons/tfi";
import { MdChair } from "react-icons/md";
import { MdGroup } from "react-icons/md";
import Chart from "react-apexcharts";


function Dashboard() {
  const [dataroom, setDataroom] = useState([]);
  const [loading, setLoading] = useState(true);
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;
  const [Count, setCount] = useState(0);



  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        Swal.fire({
          title: "กำลังโหลดข้อมูล",
          didOpen: () => Swal.showLoading(),
          allowOutsideClick: false,
        });

        const response = await fetch("https://api-esan.onrender.com/api/data/reg", {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "x-access-token": `Bearer ${Cookies.get("accessToken")}`,
          },
        });

        if (!response.ok) {
          throw new Error(`HTTP Error: ${response.status}`);
        }

        const data = await response.json();
        setDataroom(data);
        

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

  const paginate = (pageNumber) => setCurrentPage(pageNumber);
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = dataroom.slice(indexOfFirstItem, indexOfLastItem);

  

  const count1 = dataroom.length
  let total = 35 - count1;

  const payment = (URL) => {
    if (!URL) {
      Swal.fire({
        title: "ไม่มีหลักฐานการชำระเงิน",
        icon: "warning",
        text: "กรุณาอัปโหลดหลักฐานการชำระเงิน",
        showCancelButton: true,
      });
      return;
    }

    Swal.fire({
      title: "หลักฐานการชำระเงิน",
      html: `<img src="${URL}" class="w-full h-auto" />`,
      showCancelButton: true,
      confirmButtonText: "ปิด",
    });
  };

    const options = {
      chart: {
        height: 350,
        type: "bar",
      },
      plotOptions: {
        bar: {
          borderRadius: 10,
          dataLabels: {
            position: "top",
          },
        },
      },
     
      xaxis: {
        categories: [
          "โซน A", "โซน B", "โซน C", "โซน D", 
        ],
        position: "bottom",
        axisBorder: { show: false },
        axisTicks: { show: false },
        crosshairs: {
          fill: {
            type: "gradient",
            gradient: {
              colorFrom: "#D8E3E7",
              colorTo: "#BED1D6",
              stops: [0, 100],
              opacityFrom: 0.4,
              opacityTo: 0.5,
            },
          },
        },
          
      },
      yaxis: {
        axisBorder: { show: false },
        axisTicks: { show: false },
        labels: {
          show: false,
          formatter: (val) => `${val}คน`,
        },
      },
      dataLabels: {
        enabled: false
      },
      legend: {
        show: false
      },
      title: {
        floating: true,
        offsetY: 330,
        align: "center",
        style: { color: "#444" },
      },
    };

    const type_A = dataroom.filter((item) => item.seat?.seat_type === "A");
    const type_B = dataroom.filter((item) => item.seat?.seat_type === "B");
    const type_C = dataroom.filter((item) => item.seat?.seat_type === "C");
    const type_D = dataroom.filter((item) => item.seat?.seat_type === "D");
    const type_E = dataroom.filter((item) => item.seat?.seat_type === "E");

   

    const data = [
      type_A.length,
      type_B.length,
      type_C.length,
      type_D.length,
      type_E.length,
    ];
  
    const series = [
      {
        name: "จำนวนที่นั่ง",
        data: data,
      },
    ]

 
     const kmutn = dataroom.filter((item) => item.status === "เป็นศิษย์เก่าชมรมอีสานมจพ.");
   console.log(kmutn);
   

    useEffect(() => {
      setSeriesPie([
        dataroom.filter((item) => item.status === "เป็นศิษย์เก่าชมรมอีสานมจพ.").length,
        dataroom.filter((item) => item.status === "เป็นศิษย์ปัจจุบันมจพ.").length,
        dataroom.filter((item) => item.status === "สมาชิกสนอท.").length,
        dataroom.filter((item) => item.status === "อื่นๆ").length,
      ]);
    }, [dataroom]);

    const [optionsPie, setOptionsPie] = useState({
      chart: {
        type: "pie",
        width: 380,
      },
      colors: ["#775DD0", "#F39C12", "#E74C3C", "#2ECC71"],
      labels: ["เป็นศิษย์เก่าชมรมอีสาน มจพ.", "เป็นศิษย์ปัจจุบัน มจพ.", "สมาชิก สนทอ", "อื่นๆ"],
      responsive: [
        {
          breakpoint: 480,
          options: {
            chart: {
              width: 200,
            },
            legend: {
              position: "bottom",
            },
           
          },
        },
      ],
      legend: {
        position: "right",
        offsetY: 0,
        height: 230,
      },
      tooltip: {
        enabled: true,
        y: {
          formatter: (val) => `${val} คน`,
        },
      },
      
      plotOptions: {
        pie: {
          expandOnClick: true,
          dataLabels: {
            offset: 0,
            minAngleToShowLabel: 10,
          },
        
        },
      },
    });


    const [seriesPie, setSeriesPie] = useState([0, 0, 0, 0])

  const approve = (seatId) => {
    Swal.fire({
      title: "อนุมัติการชำระเงิน",
      text: "คุณต้องการอนุมัติการชำระเงินใช่หรือไม่",
      showCancelButton: true,
      confirmButtonText: "อนุมัติ",
      cancelButtonText: "ยกเลิก",
    }).then((result) => {
      if (result.isConfirmed) {
    
        fetch(`https://api-esan.onrender.com/api/approve/seat/${seatId}`, {  
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
          },
          
        })
        .then((response) => response.json())
        .then((data) => {
          Swal.fire({
            title: "อนุมัติสำเร็จ",
            icon: "success",
            text: "การชำระเงินได้รับการอนุมัติ",
          });
          
           window.location.reload();

        })
        .catch((error) => {
          console.error("Error:", error);
          Swal.fire({
            title: "เกิดข้อผิดพลาด",
            icon: "error",
            text: "ไม่สามารถอนุมัติการชำระเงินได้",
          });
        });
      }
    });
  };
  
  

  return (
    <div>
      <Navbar />
      <div className="bg-neutral-200 h-screen ">
        <div className="py-10 bg-neutral-200 ">
          <div className="container mx-auto px-4 sm:px-6 lg:px-10">

          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mt-8 py -4">
              <div className="bg-white rounded-lg shadow-md p-4">
                <p className="text-3xl font-bold text-orange-700">ยอดเงินทั้งหมด</p>
                <div className="flex justify-end ">
                <TfiMoney className="text-3xl text-orange-700" />
                </div>
                <p className="text-2xl ">
                  18,035 บาท
                </p>
                <div className="flex justify-between mt-4">
                  <p>ที่นั่งคงเหลือ </p>
                  <p> 10 ที่นั่ง </p>
                </div>
                </div>
             
               <div className="bg-white rounded-lg shadow-md p-4">
                <p className="text-3xl font-bold text-orange-700">บัตร VIP </p>
                <div className="flex justify-end ">
                <MdChair  className="text-3xl text-orange-700" />
                  </div>
                  <p className="text-2xl ">
                    17,000 บาท
                  </p>
                  <div className="flex justify-between mt-4">
                    <p>ขายได้ทั้งหมด 17 ใบ</p>
                    <p>ใบละ 1000 บาท</p>
                    </div>
                    </div>

                    <div className="bg-white rounded-lg shadow-md p-4">
                <p className="text-3xl font-bold text-orange-700">บัตรบุคคลทั่วไป</p>
                <div className="flex justify-end ">
                  <TfiMoney className="text-3xl text-orange-700" />
                  </div>
                  <p className="text-2xl ">
                     1,035 บาท
                  </p>
                  <div className="flex justify-between mt-4">
                    <p>ขายได้ทั้งหมด 15 ใบ</p>
                    <p>ใบละ 69 บาท</p>
                    </div>
                    </div>

                    <div className="bg-white rounded-lg shadow-md p-4">
                <p className="text-3xl font-bold text-orange-700">จำนวนผู้ลงทะเบียน</p>
                <div className="flex justify-end ">
                  <MdGroup  className="text-3xl text-orange-700" />
                  </div>
                  <p className="text-2xl ">
                  80  คน
                  </p>
                  <div className="flex justify-between mt-4">
                    <p>จำนวนที่นั่งทั้งหมด</p>
                    <p>28 ที่นั่ง</p>
                    </div>




                  


                  
              </div>
              </div>

              <div className="mt-8">
              <div className="bg-white rounded-lg shadow-md p-6">
                <h3 className="text-2xl font-bold mb-4">รายงาน</h3>
                <div className="flex justify-between">
                <div className="w-1/2">
                <Chart options={options} series={series} type="bar" height={350} />
                </div>
                <div className="w-1/2">
                    <Chart
                      options={optionsPie}
                      series={seriesPie}
                      type="pie"
                      height={350}
                    />
                  </div>

                </div>
                </div>
                </div>
             
           
              
              
              

            <h3 className="text-2xl font-bold mb-4  mt-6">การตอบกลับการลงทะเบียน</h3>
            <div className="mt-4 ">
              <div className="overflow-x-auto bg-white rounded-lg shadow-md p-4">
                <table className="w-full text-sm text-left text-gray-500">
                  <thead className="text-xs text-gray-700 uppercase bg-gray-50">
                    <tr>
                      <th className="px-6 py-3">ลำดับ</th>
                      <th className="px-6 py-3">ชื่อ-นามสกุล</th>
                      <th className="px-6 py-3">สถานะ</th>
                      <th className="px-6 py-3">มหาวิทยาลัย</th>
                      <th className="px-6 py-3">เลขที่นั่ง</th>
                      <th className="px-6 py-3">สถานะการชำระเงิน</th>
                      <th className="px-6 py-3">จัดการ</th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y">
                    {currentItems.length === 0 ? (
                      <tr>
                        <td colSpan="7" className="text-center px-6 py-4 text-gray-700">
                          ไม่มีข้อมูล
                        </td>
                      </tr>
                    ) : (
                      currentItems.map((item, index) => (
                        <tr key={item.id}>
                          <td className="px-6 py-4 text-gray-700">{indexOfFirstItem + index + 1}</td>
                          <td className="px-6 py-4 text-gray-700">
                            {item.first_name + " " + item.last_name}
                          </td>
                          <td className="px-6 py-4 text-gray-700">
                      
                              <span className="bg-indigo-200 text-indigo-600 py-1 px-3 rounded-full text-xs mt-4">
                                 {item.status }
                              </span>
                           
                          </td>
                          <td className="px-6 py-4 text-gray-700">
                            {item.university || "ไม่มีข้อมูล"}
                          </td>
                          <td className="px-6 py-4 text-gray-700">
                            {item.seat?.seat_number?.toString() || "ไม่มีข้อมูล"}
                          </td>
                          <td className="px-6 py-4 text-gray-700">
                            {item.seat.seat_status === "Payment" ? (
                              <span className="bg-red-200 text-red-600 py-1 px-3 rounded-full text-xs">
                                รออนุมัติ
                              </span>
                            ) : (
                              <span className="text-green-600 bg-green-200 py-1 px-3 rounded-full text-xs">
                                สำเร็จ
                              </span>
                            )}
                          </td>
                          <td className="px-6 py-4 text-gray-700">
                          {item.seat.seat_status === "Payment" ? (
  <>
    <button
      onClick={() => approve(item.seatId)}
     className="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-full ml-2"
    >
      อนุมัติ
    </button>

    <button
      onClick={() => payment(item.URL)}
      className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full ml-2"
    >
      ดูสลิป
    </button>
  </>
) : (
  <button
  onClick={() => payment(item.URL)}
  className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full ml-2"
>
  ดูสลิป
</button>

)}

                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
                <div className="pagination mt-4 flex justify-center">
                  {Array.from({ length: Math.ceil(dataroom.length / itemsPerPage) }, (_, i) => i + 1).map((number) => (
                    <button key={number} onClick={() => paginate(number)} className={`px-3 py-1 rounded-full mx-1 ${currentPage === number ? "bg-orange-800 text-white" : "bg-gray-500 text-white"}`}>
                      {number}
                    </button>
                  ))}
                </div>
              </div>

             



            </div>
           
          </div>
           
        </div>
      </div>
    </div>
  );
}

export default Dashboard;
