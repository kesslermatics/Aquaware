import React from "react";
import { check } from "../assets";
import Heading from "./Heading";

const ComparePlans = () => {
  return (
    <div className="flex flex-col items-center justify-center text-center mb-8">
      <Heading tag="To your tailored needs" title="Compare Plans" />
      <div className="overflow-x-auto w-full">
        <table className="table-auto bg-n-8 border-collapse text-center mx-auto">
          <thead>
            <tr>
              <th className="p-4"></th>
              <th className="p-4 text-xl font-bold">
                Hobby Plan
                <div className="text-sm font-normal">$0 per month</div>
              </th>
              <th className="p-4 text-xl font-bold">
                Advanced Plan
                <div className="text-sm font-normal">$2.99 per month</div>
              </th>
              <th className="p-4 text-xl font-bold">
                Premium Plan
                <div className="text-sm font-normal">$5.99 per month</div>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td className="p-4 text-start">Monitor all water parameters</td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>
            <tr>
              <td className="p-4 text-start">
                Access to real-time data visualization
              </td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>
            <tr>
              <td className="p-4 text-start">Upload frequency</td>
              <td className="p-4">Every 2 hours</td>
              <td className="p-4">Every 30 minutes</td>
              <td className="p-4">Every 30 minutes</td>
            </tr>
            <tr>
              <td className="p-4 text-start">Add alerts and notifications</td>
              <td className="p-4">—</td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>
            <tr>
              <td className="p-4 text-start">
                Public environments for data sharing
              </td>
              <td className="p-4">—</td>
              <td className="p-4">—</td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>
            <tr>
              <td className="p-4 text-start">
                Identify Fish with AI
              </td>
              <td className="p-4">—</td>
              <td className="p-4">—</td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>
            <tr>
              <td className="p-4 text-start">
                Fish Disease Detection
              </td>
              <td className="p-4">—</td>
              <td className="p-4">—</td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>
            <tr>
              <td className="p-4 text-start">
                Water Parameter Prediction (coming soon)
              </td>
              <td className="p-4">—</td>
              <td className="p-4">—</td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default ComparePlans;
