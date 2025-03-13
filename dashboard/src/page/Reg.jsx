import React, { useEffect, useState } from "react";
import Navbar from "../components/Navbar";
import Swal from "sweetalert2";
import Cookies from "js-cookie";
import { TfiMoney } from "react-icons/tfi";
import { MdChair } from "react-icons/md";
import { MdGroup } from "react-icons/md";
import Chart from "react-apexcharts";
import { GiLockers } from "react-icons/gi";
import { FaUserLock } from "react-icons/fa";
import { BsUnlock } from "react-icons/bs";
import { AiOutlineClose } from "react-icons/ai";

function Dashboard() {
  const [data, setdata] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(
          "https://demos.wutthiphon.space/lab/ubuntu/serv/101/api/dashboard/getdata",
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );

        const data = await response.json();
        setdata(data);
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  }, []);

  const lockerCount = data?.lockerlist?.length || 0;
  const locker_notuse_count = data?.locker_notuse_count?.length || 0;

  const lockerNums =
    data?.lockerlist?.map((locker) => `locker_num ${locker.locker_num}`) || [];
  const locker_history =
    data?.lockerlist?.map((locker) => locker.locker_count) || [];

  const RevenuChartCardData = {
    height: 280,
    type: "donut",
    options: {
      dataLabels: {
        enabled: false,
      },
      yaxis: {
        min: 0,
        max: 100,
      },
      labels: lockerNums,
      legend: {
        show: true,
        position: "bottom",
        fontFamily: "inherit",
        labels: {
          colors: "inherit",
        },
      },
      itemMargin: {
        horizontal: 10,
        vertical: 10,
      },
      // ใช้ colors แบบสุ่ม ตามจำนวน lockerNums แต่ไม่มีสีขาวหรือสีอ่อน
      colors: lockerNums.map(() => {
        let color;
        while (!color || parseInt(color.substring(1), 16) > 0xeeeeee) {
          color = `#${Math.floor(Math.random() * 16777215)
            .toString(16)
            .padStart(6, "0")}`;
        }
        return color;
      }),
    },
    series: locker_history,
  };

  // จับคู่ locker_num และ locker_count แล้วเรียงลำดับตาม locker_count
  const sortedLockerList =
    data?.lockerlist?.sort(data.lockerlist.locker_num) || [];

  // console.log(sortedLockerList);

  // ดึงข้อมูล locker_num ที่เรียงลำดับแล้ว
  const locker_Nums = sortedLockerList.map(
    (locker) => `locker_num ${locker.locker_num}`
  );

  // ดึงข้อมูล locker_count ที่เรียงลำดับแล้ว
  const locker_history1 = sortedLockerList.map((locker) => locker.locker_count);
  const locker_status = sortedLockerList.map((locker) => locker.locker_status);

  // สร้าง dataSetline ที่มีข้อมูลที่เรียงลำดับแล้ว
  const dataSetline = {
    labels: locker_Nums,
    locker_history: locker_history1,
    locker_status: locker_status,
  };

  const chartData = {
    type: "bar", // เปลี่ยนเป็นกราฟแท่ง (Bar chart)
    height: 300, // ความสูงของกราฟ
    options: {
      // การตั้งค่ากราฟ
      dataLabels: {
        enabled: true, // เปิดการแสดง data labels
      },
      colors: ["#009966"], // สีของกราฟ
      fill: {
        type: "gradient", // ใช้สีแบบกระจาย
        gradient: {
          shade: "light", // ใช้สีอ่อน
          type: "vertical", // ใช้สีแนวตั้ง
          shadeIntensity: 0.5, // ความเข้มของสี
          gradientToColors: ["#009966"], // สีของกราฟ
          inverseColors: false, // ไม่ใช้สีสลับ
          opacityFrom: 1, // ความโปร่งใสของสี
          opacityTo: 1, // ความโปร่งใสของสี
        },
      },
      stroke: {
        curve: "smooth", // ใช้เส้นโค้ง
        width: 3, // ความหนาของเส้น
      },
      yaxis: {
        min: 0, // ค่าต่ำสุดของแกน Y
        max: Math.max(...dataSetline.locker_history) + 5, // ค่าสูงสุดของแกน Y
      },
      tooltip: {
        theme: "light", // ใช้ธีมอ่อน
        fixed: {
          enabled: false, // ปิดการแสดงผลแบบติด
        },
        x: {
          title: {
            labels: {
              show: true, // แสดงป้ายของแกน X
            },
          },
        },
        y: {
          title: {
            formatter: () => "Locker Count", // ตั้งชื่อให้แกน Y
          },
        },
        marker: {
          show: false, // ปิด marker
        },
      },
      xaxis: {
        categories: dataSetline.locker_num || [], // แกน X คือ locker_num
        title: {
          text: "Locker Numbers", // ชื่อของแกน X
        },
      },
    },
    series: [
      {
        name: "Locker Count",
        data: dataSetline.locker_history || [],
      },
    ],
  };

  const lockerNotUse = data.locker_notuse_count || [];
  const lockerList = data.lockerlist || [];

  // สร้าง Set ของ locker_id ที่ไม่ว่าง
  const notAvailableLockers = new Set(lockerNotUse.map((l) => l.locker_id));

  // ตรวจสอบว่าล็อกเกอร์แต่ละตัวว่างหรือไม่
  const lockerStatus = lockerList
    .map((locker) => ({
      locker_num: locker.locker_num,
      status: notAvailableLockers.has(locker.locker_id) ? "1" : "0",
    }))
    .sort((a, b) => a.locker_num - b.locker_num);

  return (
    <div>
      <Navbar />
      <div className="bg-neutral-200 h-screen ">
        <div className="py-10 bg-neutral-200 ">
          <div className="container mx-auto px-4 sm:px-6 lg:px-10">
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mt-8 py -4">
              <div className="bg-white rounded-lg shadow-md p-4">
                <p className="text-2xl font-bold text-blue-500">
                  Total Lockers
                </p>
                <div className="flex justify-end ">
                  <GiLockers className="text-3xl text-blue-500" />
                </div>
                <p className="text-2xl ">{lockerCount} lockers</p>

                <div className="flex justify-between mt-4">
                  <p>จำนวนล็อกเกอร์ทั้งหมด </p>
                  <p> {lockerCount} ตัว</p>
                </div>
              </div>

              <div className="bg-white rounded-lg shadow-md p-4">
                <p className="text-2xl font-bold text-red-500">
                  Occupied Lockers{" "}
                </p>
                <div className="flex justify-end ">
                  <FaUserLock className="text-3xl text-red-500" />
                </div>
                <p className="text-2xl ">
                  {lockerCount - locker_notuse_count} lockers
                </p>
                <div className="flex justify-between mt-4">
                  <p>จำนวนล็อกเกอร์ที่ใช้งาน</p>
                  <p>{lockerCount - locker_notuse_count} อัน</p>
                </div>
              </div>

              <div className="bg-white rounded-lg shadow-md p-4">
                <p className="text-2xl font-bold text-green-500">
                  Available Lockers
                </p>
                <div className="flex justify-end ">
                  <BsUnlock className="text-3xl text-green-500" />
                </div>
                <p className="text-2xl ">{locker_notuse_count} lockers</p>
                <div className="flex justify-between mt-4">
                  <p>จำนวนล็อกเกอร์ว่าง</p>
                  <p> {locker_notuse_count} อัน</p>
                </div>
              </div>

              <div className="bg-white rounded-lg shadow-md p-4">
                <p className="text-2xl font-bold text-yellow-500">
                  Total Users
                </p>
                <div className="flex justify-end ">
                  <MdGroup className="text-3xl text-yellow-500" />
                </div>
                <p className="text-2xl ">{data.user_count} users</p>
                <div className="flex justify-between mt-4">
                  <p>จำนวนผู้ใช้งาน</p>
                  <p> {data.user_count} คน</p>
                </div>
              </div>
            </div>

            <div className="mt-8">
              <div className="bg-white rounded-lg shadow-md p-6">
                <h3 className="text-2xl font-bold mb-2">
                  Locker Booking History
                </h3>
                <div className="flex justify-between">
                  <div className="w-1/2">
                    <Chart
                      options={chartData.options}
                      series={chartData.series}
                      type={chartData.type}
                    />
                  </div>
                  <div className="w-1/2">
                    <Chart
                      options={RevenuChartCardData.options}
                      series={RevenuChartCardData.series}
                      type={RevenuChartCardData.type}
                      height={RevenuChartCardData.height}
                    />
                  </div>
                </div>
              </div>
            </div>

            <div className="mt-8">
              <div className="bg-white rounded-lg shadow-md p-6">
                <h3 className="text-2xl font-bold mb-2">Locker Status</h3>
                <table className="min-w-full table-auto">
                  <thead>
                    <tr>
                      <th className="px-4 py-2 text-left">Locker Number</th>
                      <th className="px-4 py-2 text-left">Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {lockerStatus.map((locker, index) => (
                      <tr key={index} className="border-t">
                        <td className="px-4 py-2">{locker.locker_num}</td>
                        <td
                          className={`px-4 py-2 flex items-center ${
                            locker.status === "1"
                              ? "text-red-500"
                              : "text-green-500"
                          }`}
                        >
                          {locker.status === "1" ? (
                            <>
                              <AiOutlineClose className="w-5 h-5 mr-2 text-red-500" />
                              Occupied
                            </>
                          ) : (
                            <>
                              <svg
                                className="w-5 h-5 mr-2 text-green-500"
                                xmlns="http://www.w3.org/2000/svg"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke="currentColor"
                              >
                                <path
                                  strokeLinecap="round"
                                  strokeLinejoin="round"
                                  strokeWidth="2"
                                  d="M5 13l4 4L19 7"
                                />
                              </svg>
                              Available
                            </>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;
