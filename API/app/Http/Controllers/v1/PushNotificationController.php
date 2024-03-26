<?php

namespace App\Http\Controllers\v1;

use App\Http\Controllers\Controller;
use App\Models\PushNotification;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Auth;
use Validator;
use DB;

class PushNotificationController extends Controller
{
    public function sendToAllUsers( Request $request )
    {
        try {
            $validator = Validator::make($request->all(), [
                'title' => 'required',
                'message' => 'required',
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

            $data = DB::table('settings')
                ->select('*')->first();
            $ids = explode(',', $request->id);
            $allIds = DB::table('users')->select('fcm_token')->get();
            $fcm_ids = array();
            foreach ($allIds as $i => $i_value) {
                if ($i_value->fcm_token != 'NA' && $i_value->fcm_token != null) {
                    array_push($fcm_ids, $i_value->fcm_token);
                }
            }

            if (is_null($data)) {
                $response = [
                    'data' => false,
                    'message' => 'Data not found.',
                    'status' => 404
                ];
                return response()->json($response, 200);
            }
            $regIdChunk = array_chunk($fcm_ids, 1000);
            foreach ($regIdChunk as $RegId) {
                $header = array();
                $header[] = 'Content-type: application/json';
                $header[] = 'Authorization: key=' . $data->fcm_token;

                $payload = [
                    'registration_ids' => $RegId,
                    'priority' => 'high',
                    'notification' => [
                        'title' => $request->title,
                        'body' => $request->message,
                        'image' => $request->cover,
                        "sound" => "wave.wav",
                        "channelId" => "fcm_default_channel"
                    ],
                    'android' => [
                        'notification' => [
                            "sound" => "wave.wav",
                            "defaultSound" => true,
                            "channelId" => "fcm_default_channel"
                        ]
                    ]
                ];

                $crl = curl_init();
                curl_setopt($crl, CURLOPT_HTTPHEADER, $header);
                curl_setopt($crl, CURLOPT_POST, true);
                curl_setopt($crl, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
                curl_setopt($crl, CURLOPT_POSTFIELDS, json_encode($payload));

                curl_setopt($crl, CURLOPT_RETURNTRANSFER, true);

                $rest = curl_exec($crl);
                if ($rest === false) {
                    return curl_error($crl);
                }
                curl_close($crl);
            }
            $response = [
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);


        } catch (Exception $e) {
            return response()->json($e->getMessage(), 200);
        }
    }

    public function sendToUsers( Request $request )
    {
        try {
            $validator = Validator::make($request->all(), [
                'title' => 'required',
                'message' => 'required',
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

            $data = DB::table('settings')
                ->select('*')->first();
            $ids = explode(',', $request->id);
            $allIds = DB::table('users')->where('type', 'user')->select('fcm_token')->get();
            $fcm_ids = array();
            foreach ($allIds as $i => $i_value) {
                if ($i_value->fcm_token != 'NA' && $i_value->fcm_token != null) {
                    array_push($fcm_ids, $i_value->fcm_token);
                }
            }


            if (is_null($data)) {
                $response = [
                    'data' => false,
                    'message' => 'Data not found.',
                    'status' => 404
                ];
                return response()->json($response, 200);
            }
            $regIdChunk = array_chunk($fcm_ids, 1000);
            foreach ($regIdChunk as $RegId) {
                $header = array();
                $header[] = 'Content-type: application/json';
                $header[] = 'Authorization: key=' . $data->fcm_token;

                $payload = [
                    'registration_ids' => $RegId,
                    'priority' => 'high',
                    'notification' => [
                        'title' => $request->title,
                        'body' => $request->message,
                        'image' => $request->cover,
                        "sound" => "wave.wav",
                        "channelId" => "fcm_default_channel"
                    ],
                    'android' => [
                        'notification' => [
                            "sound" => "wave.wav",
                            "defaultSound" => true,
                            "channelId" => "fcm_default_channel"
                        ]
                    ]
                ];

                $crl = curl_init();
                curl_setopt($crl, CURLOPT_HTTPHEADER, $header);
                curl_setopt($crl, CURLOPT_POST, true);
                curl_setopt($crl, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
                curl_setopt($crl, CURLOPT_POSTFIELDS, json_encode($payload));

                curl_setopt($crl, CURLOPT_RETURNTRANSFER, true);

                $rest = curl_exec($crl);
                if ($rest === false) {
                    return curl_error($crl);
                }
                curl_close($crl);
            }
            $response = [
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);


        } catch (Exception $e) {
            return response()->json($e->getMessage(), 200);
        }
    }


    public function getAllNotifications() {
        try {
            $notifications = PushNotification::all();
            return response()->json([
                'notifications' => $notifications,
                'success' => true,
                'status' => 200
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => $e->getMessage(),
                'success' => false,
                'status' => 500
            ], 500);
        }
    }

    public function sendToStores( Request $request )
    {
        try {
            $validator = Validator::make($request->all(), [
                'title' => 'required',
                'message' => 'required',
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

            $data = DB::table('settings')
                ->select('*')->first();
            $ids = explode(',', $request->id);
            $allIds = DB::table('users')->where('type', 'individual')->select('fcm_token')->get();
            $fcm_ids = array();
            foreach ($allIds as $i => $i_value) {
                if ($i_value->fcm_token != 'NA' && $i_value->fcm_token != null) {
                    array_push($fcm_ids, $i_value->fcm_token);
                }
            }


            if (is_null($data)) {
                $response = [
                    'data' => false,
                    'message' => 'Data not found.',
                    'status' => 404
                ];
                return response()->json($response, 200);
            }
            $regIdChunk = array_chunk($fcm_ids, 1000);
            foreach ($regIdChunk as $RegId) {
                $header = array();
                $header[] = 'Content-type: application/json';
                $header[] = 'Authorization: key=' . $data->fcm_token;

                $payload = [
                    'registration_ids' => $RegId,
                    'priority' => 'high',
                    'notification' => [
                        'title' => $request->title,
                        'body' => $request->message,
                        'image' => $request->cover,
                        "sound" => "wave.wav",
                        "channelId" => "fcm_default_channel"
                    ],
                    'android' => [
                        'notification' => [
                            "sound" => "wave.wav",
                            "defaultSound" => true,
                            "channelId" => "fcm_default_channel"
                        ]
                    ]
                ];

                $crl = curl_init();
                curl_setopt($crl, CURLOPT_HTTPHEADER, $header);
                curl_setopt($crl, CURLOPT_POST, true);
                curl_setopt($crl, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
                curl_setopt($crl, CURLOPT_POSTFIELDS, json_encode($payload));

                curl_setopt($crl, CURLOPT_RETURNTRANSFER, true);

                $rest = curl_exec($crl);
                if ($rest === false) {
                    return curl_error($crl);
                }
                curl_close($crl);
            }
            $response = [
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);


        } catch (Exception $e) {
            return response()->json($e->getMessage(), 200);
        }
    }

    public function sendToSalon( Request $request )
    {
        try {
            $validator = Validator::make($request->all(), [
                'title' => 'required',
                'message' => 'required',
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

            $data = DB::table('settings')
                ->select('*')->first();
            $ids = explode(',', $request->id);
            $allIds = DB::table('users')->where('type', 'salon')->select('fcm_token')->get();
            $fcm_ids = array();
            foreach ($allIds as $i => $i_value) {
                if ($i_value->fcm_token != 'NA' && $i_value->fcm_token != null) {
                    array_push($fcm_ids, $i_value->fcm_token);
                }
            }


            if (is_null($data)) {
                $response = [
                    'data' => false,
                    'message' => 'Data not found.',
                    'status' => 404
                ];
                return response()->json($response, 200);
            }
            $regIdChunk = array_chunk($fcm_ids, 1000);
            foreach ($regIdChunk as $RegId) {
                $header = array();
                $header[] = 'Content-type: application/json';
                $header[] = 'Authorization: key=' . $data->fcm_token;

                $payload = [
                    'registration_ids' => $RegId,
                    'priority' => 'high',
                    'notification' => [
                        'title' => $request->title,
                        'body' => $request->message,
                        'image' => $request->cover,
                        "sound" => "wave.wav",
                        "channelId" => "fcm_default_channel"
                    ],
                    'android' => [
                        'notification' => [
                            "sound" => "wave.wav",
                            "defaultSound" => true,
                            "channelId" => "fcm_default_channel"
                        ]
                    ]
                ];

                $crl = curl_init();
                curl_setopt($crl, CURLOPT_HTTPHEADER, $header);
                curl_setopt($crl, CURLOPT_POST, true);
                curl_setopt($crl, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
                curl_setopt($crl, CURLOPT_POSTFIELDS, json_encode($payload));

                curl_setopt($crl, CURLOPT_RETURNTRANSFER, true);

                $rest = curl_exec($crl);
                if ($rest === false) {
                    return curl_error($crl);
                }
                curl_close($crl);
            }
            $response = [
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);


        } catch (Exception $e) {
            return response()->json($e->getMessage(), 200);
        }
    }

    public function sendNotification( Request $request )
    {
        try {
            $validator = Validator::make($request->all(), [
                'title' => 'required',
                'message' => 'required',
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

            $loggedInUserId = Auth::id();
            $data = DB::table('settings')
                ->select('*')->first();
            if (is_null($data)) {
                $response = [
                    'data' => false,
                    'message' => 'Data not found.',
                    'status' => 404
                ];
                return response()->json($response, 200);
            }
            $header = array();
            $header[] = 'Content-type: application/json';
            $header[] = 'Authorization: key=' . $data->fcm_token;
            $userFCM = DB::table('users')->where('id', $request->id)->select('*')->first();
            $payload = [
                'to' => $userFCM->fcm_token,
                'priority' => 'high',
                'notification' => [
                    'title' => $request->title,
                    'body' => $request->message,
                    "sound" => "wave.wav",
                    "channelId" => "fcm_default_channel"
                ],
                'data' => $request->data,
                'android' => [
                    'notification' => [
                        "sound" => "wave.wav",
                        "defaultSound" => true,
                        "channelId" => "fcm_default_channel"
                    ]
                ]
            ];
            $crl = curl_init();
            curl_setopt($crl, CURLOPT_HTTPHEADER, $header);
            curl_setopt($crl, CURLOPT_POST, true);
            curl_setopt($crl, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
            curl_setopt($crl, CURLOPT_POSTFIELDS, json_encode($payload));

            curl_setopt($crl, CURLOPT_RETURNTRANSFER, true);

            $rest = curl_exec($crl);


            $restObject = json_decode($rest);

            // print_r($rest);
            // print_r($request->id);
            // print_r($restObject);
            if ($rest === false || $restObject == null) {
                return curl_error($crl);
            }
            curl_close($crl);

            if ($restObject->success != false) {
                // Create a new pushNotification instance
                $pushNotification = new PushNotification();
                $pushNotification->user_id = $request->id;

                if (isset($restObject->results[0]->message_id)) {
                    $pushNotification->notification_id = $restObject->results[0]->message_id;
                }
                $pushNotification->title = $request->title;
                $pushNotification->message = $request->message;
                $pushNotification->data = json_encode($request->data);
                // print_r($pushNotification);

                // Save the pushNotification
                $pushNotification->save();
            }

            return $rest;


        } catch (Exception $e) {
            return response()->json($e->getMessage(), 200);
        }
    }

    public function getMyNotificationData( Request $request )
    {
        // $validator = Validator::make($request->all(), [
        //     'uid' => 'required',
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
        $loggedInUser = Auth::user();
        $notifications = $loggedInUser->pushNotifications;
        if (is_null($notifications)) {
            $response = [
                'data' => $notifications,
                'message' => 'error',
                'status' => 500,
            ];
            return response()->json($response, 200);
        }
        $response = [
            'data' => $notifications,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }
    public function deletePushNotification( Request $request )
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
        $loggedInUser = Auth::user();
        $notifications = $loggedInUser->pushNotifications;
        $data = PushNotification::find($request->id);
        if ($data) {
            $data->delete();
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
}
