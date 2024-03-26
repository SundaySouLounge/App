<?php

namespace App\Http\Controllers\v1;

use App\Http\Controllers\Controller;
use App\Models\EventContract;
use Illuminate\Http\Request;
use App\Models\Salon;
use App\Models\Individual;
use Illuminate\Support\Facades\Auth;
use Validator;
use App\Http\Controllers\v1\PushNotificationController;
use Carbon\Carbon;
use Illuminate\Support\Facades\Mail;
use App\Models\Settings;
use App\Models\User;
use App\Models\Services;
use App\Models\Packages;
use DB;


class EventContractController extends Controller
{
    public function getAll()
    {
        $data = EventContract::all();

        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }
        $response = [
            'data' => $data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getById( Request $request )
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
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

        $data = EventContract::find($request->id);
        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }

        $response = [
            'data' => $data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function save( Request $request )
{
    $validator = Validator::make($request->all(), [
        'date' => 'required',
        'time' => 'required',
        'band_size' => 'required',
        'fee' => 'required',
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

    // Create an instance of the PushNotificationController
    $userInfo = Auth::user();
    $requestData = $request->all();
    $requestData['user_id'] = $userInfo->id;

    // to send owner
    if ($request->salon_id) {
        $requestData['salon_uid'] = Salon::find($request->salon_id)->uid;
    } else if ($request->individual_id) {
        $requestData['individual_uid'] = Individual::find($request->individual_id)->uid;
    }

    $data = EventContract::create($requestData);

    if (is_null($data)) {
        $response = [
            'data' => $data,
            'message' => 'error',
            'status' => 500,
        ];
        return response()->json($response, 200);
    }
    $pushNotificationController = new PushNotificationController();

    // $request->merge(['custom_param' => 'custom_value']);
    
    // print_r($request->data);

    // to send owner
    if ($request->salon_id) {
        $request['id'] = Salon::find($request->salon_id)->uid;
        $venueName = $requestData['venue_name'] ?? 'Unknown Venue';
        $date = isset($requestData['date']) ? Carbon::parse($requestData['date'])->format('Y-m-d \TH:i') : 'Unknown Date';
        $additionalText = ' has sent you a contract!';
        $request['title'] = $venueName . $additionalText;
        $request['message'] = $date;
        $request['data'] = [
            'screen' => '/notifications',
            'event_contract_id' => $data->id,
        ];

        
    } else if ($request->individual_id) {
            $request['id'] = Individual::find($request->individual_id)->uid;
            $venueName = $requestData['venue_name'] ?? 'Unknown Venue';
        $date = isset($requestData['date']) ? Carbon::parse($requestData['date'])->format('Y-m-d \TH:i') : 'Unknown Date';
        $additionalText = ' has sent you a contract!';
        $request['title'] = $venueName . $additionalText;
        $request['message'] = $date;
        $request['data'] = [
            'screen' => '/notifications',
            'event_contract_id' => $data->id,
        ];

        
    }else if( $request['id'] = $userInfo->id){
        $request['title'] = 'User Event Request';
        $request['message'] = 'Created new Event Contract. Please confirm it';
        $request['data'] = [
            'screen' => '/notifications',
            'event_contract_id' => $data->id,
        ];
        $pushNotificationController->sendNotification($request);
    }

    $pushNotificationController->sendNotification($request);
        \Log::info($request->all());

    $settings = Settings::take(1)->first(); // Assuming you fetch your settings
    $generalInfo = Settings::take(1)->first();

    // Fixed email address
    $fixedEmail = "admin@sundaysoullounge.co.uk";

    Mail::send('mails/rossevent', [
        'app_name' => $settings->name,
    ], function ($message) use ($fixedEmail, $settings) {
        $message->to($fixedEmail, 'Ross check')
            ->subject('New Event');
        $message->from($settings->email, $settings->name);
    });
    $user = User::find($userInfo->id);

    // Retrieve the email address of the user
    $userEmail = $user->email;

    // Pass the user's email to the Mail::send() function
    Mail::send('mails/event', [
        'app_name' => $settings->name,
    ], function ($message) use ($userEmail, $settings) {
        $message->to($userEmail, 'Recipient Name') // Change 'Recipient Name' as needed
            ->subject('New Event');
        $message->from($settings->email, $settings->name);
    });


    if ($request->salon_id) {
        // Find the salon using the salon_id
        $salon = Salon::find($request->salon_id);

        // Check if the salon exists and if it has an associated user
        if ($salon && $salon->uid) {
            $salonUser = User::find($salon->uid);
            if($salonUser){
                // Retrieve the email address of the salon owner using the user's uid
                $salonOwnerEmail = $salonUser->email;

                // Pass the salon owner's email to the Mail::send() function
                Mail::send('mails/event', [
                    'app_name' => $settings->name,
                ], function ($message) use ($salonOwnerEmail, $settings) {
                    $message->to($salonOwnerEmail, 'Salon Owner Name') // Change 'Salon Owner Name' as needed
                        ->subject('New Event');
                    $message->from($settings->email, $settings->name);
                });
            }
        } else {
            // Log an error or handle the case where the salon or user is not found
            \Log::error('Salon or user not found for salon_id: ' . $request->salon_id);
        }
    } else if ($request->individual_id) {
        // Find the individual using the individual_id
        $individual = Individual::find($request->individual_id);

        // Check if the individual exists and if it has an associated user
        if ($individual && $individual->uid) {
            $individualUser = User::find($individual->uid);
            if($individualUser){
                // Retrieve the email address of the individual using the user's uid
                $individualEmail = $individualUser->email;

                // Pass the individual's email to the Mail::send() function
                Mail::send('mails/event', [
                    'app_name' => $settings->name,
                ], function ($message) use ($individualEmail, $settings) {
                    $message->to($individualEmail, 'Individual Name') // Change 'Individual Name' as needed
                        ->subject('New Event');
                    $message->from($settings->email, $settings->name);
                });
            }
        } else {
            // Log an error or handle the case where the individual or user is not found
            \Log::error('Individual or user not found for individual_id: ' . $request->individual_id);
        }
    }




    $response = [
        'data' => $data,
        'success' => true,
        'status' => 200,
    ];

    return response()->json($response, 200);
}

    public function update( Request $request )
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
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
        $data = EventContract::find($request->id)->update($request->all());

        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }

        $data = EventContract::find($request->id);

        $response = [
            'data' => $data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function delete( Request $request )
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
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
        $data = EventContract::find($request->id)->delete();
        if ($data) {
            $response = [
                'data' => $data,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        }
        $response = [
            'success' => false,
            'message' => 'Data not found.',
            'status' => 404
        ];
        return response()->json($response, 404);
    }

    public function getMyEventContracts( Request $request )
    {
        // $validator = Validator::make($request->all(), [
        //     'salon_id' => 'required',
        //     'individual_id' => 'required',
        // ]);
        // if ($validator->fails()) {
        //     $response = [
        //         'success' => false,
        //         'message' => 'Validation Error.',
        //         $validator->errors(),
        //         'status' => 500
        //     ];
        //     return response()->json($response, 404);
        // }

        $loggedInUserId = Auth::id();
        $data = EventContract::where('user_id', $loggedInUserId)->get();

        if (is_null($data)) {
            $response = [
                'data' => $data,
                'message' => 'error',
                'status' => 500,
            ];
            return response()->json($response, 200);
        }

        $response = [
            'data' => $data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getSavedEventContracts( Request $request )
    {
        // $validator = Validator::make($request->all(), [
        //     'salon_id' => 'required',
        //     'individual_id' => 'required',
        // ]);
        // if ($validator->fails()) {
        //     $response = [
        //         'success' => false,
        //         'message' => 'Validation Error.',
        //         $validator->errors(),
        //         'status' => 500
        //     ];
        //     return response()->json($response, 404);
        // }

        if ($request->salon_id) {
            $data = Salon::find($request->salon_id)->eventContracts;
        } else if ($request->individual_id) {
            $data = Individual::find($request->individual_id)->eventContracts;
        }

        if (is_null($data)) {
            $response = [
                'data' => $data,
                'message' => 'error',
                'status' => 500,
            ];
            return response()->json($response, 200);
        }

        $response = [
            'data' => $data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getSavedEventContractsByUid( Request $request )
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
            $data = Individual::where('uid', $request->id)->first()->eventContracts;
        }

        if ($request->type == 'salon') {
            $data = Salon::where('uid', $request->id)->first()->eventContracts;
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
}
