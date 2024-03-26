<?php

namespace App\Http\Controllers\v1;

use App\Http\Controllers\Controller;
use App\Models\UnavailableDate;
use Illuminate\Http\Request;
use App\Models\Salon;
use App\Models\Individual;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Auth;
use Validator;
use DB;

class UnavailableDateController extends Controller
{
    public function getUnavailableDatesById( Request $request )
    {
        if ($request->salon_id) {
            $data = Salon::where('id', $request->salon_id)->firstOrFail()
                ->unavailableDates()
                ->pluck('unavailable_date')
                ->toArray();
        }
        if ($request->individual_id) {
            $data = Individual::where('id', $request->individual_id)->firstOrFail()
                ->unavailableDates()
                ->pluck('unavailable_date')
                ->toArray();
        }

        if (isset($data) && $data) {
            $response = [
                'data' => $data,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        } else {
            $response = [
                'data' => [],
                'success' => false,
                'status' => 200
            ];
            return response()->json($response, 200);
        }
    }

    public function getUnavailableDatesByUid( Request $request )
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
            'type' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.',
                $validator->errors(),
                'status' => 500
            ];
            return response()->json($response, 404);
        }
        if ($request->type == 'individual') {
            $data = Individual::where('uid', $request->id)->firstOrFail()
                ->unavailableDates()
                ->pluck('unavailable_date')
                ->toArray();
        }

        if ($request->type == 'salon') {
            $data = Salon::where('uid', $request->id)->firstOrFail()
                ->unavailableDates()
                ->pluck('unavailable_date')
                ->toArray();
        }
        if (isset($data) && $data) {
            $response = [
                'data' => $data,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        } else {
            $response = [
                'data' => [],
                'success' => false,
                'status' => 200
            ];
            return response()->json($response, 200);
        }
    }

    public function updateUnavailableDatesByUid( Request $request )
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
            'type' => 'required',
            'dates' => 'required',
        ]);

        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.',
                'errors' => $validator->errors(),
                'status' => 500
            ];
            return response()->json($response, 404);
        }

        if ($request->type == 'individual') {
            $individual = Individual::where('uid', $request->id)->firstOrFail();

            if (!$individual) {
                $response = [
                    'data' => [],
                    'success' => false,
                    'message' => 'Individual not found.',
                    'status' => 404
                ];
                return response()->json($response, 404);
            }

            // Delete existing unavailable dates for the individual
            //$individual->unavailableDates()->delete();

            // Add new unavailable dates
            foreach ($request->dates as $date) {
                $individual->unavailableDates()->create([
                    'unavailable_date' => Carbon::parse($date)->toDateString()
                ]);
            }
        }

        if ($request->type == 'salon') {
            $salon = Salon::where('uid', $request->id)->firstOrFail();

            if (!$salon) {
                $response = [
                    'data' => [],
                    'success' => false,
                    'message' => 'Salon not found.',
                    'status' => 404
                ];
                return response()->json($response, 404);
            }

            // Delete existing unavailable dates for the salon
            //$salon->unavailableDates()->delete();

            // Add new unavailable dates
            foreach ($request->dates as $date) {
                $salon->unavailableDates()->create([
                    'unavailable_date' => Carbon::parse($date)->toDateString()
                ]);
            }
        }

        $response = [
            'data' => $request->dates,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }
}
