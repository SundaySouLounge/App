<?php

namespace App\Http\Controllers\v1;

use App\Http\Controllers\Controller;
use App\Models\PushNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use JWTAuth;
use Illuminate\Hashing\BcryptHasher;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Arr;
use Carbon\Carbon;
use App\Models\Individual;
use App\Models\Salon;
use App\Models\Settings;
use App\Models\ReferralCodes;
use App\Models\Otp;
use App\Models\Appointments;
use App\Models\Products;
use App\Models\ProductOrders;
use App\Models\Complaints;
use App\Models\Services;
use App\Models\Packages;
use App\Models\Category;
use App\Models\Banners;
use App\Models\Cities;
use App\Models\EventContract;
use Illuminate\Support\Facades\Auth;
use Validator;
use Artisan;
use DB;
use Illuminate\Support\Facades\Date;
use Symfony\Component\Mime\Part\Multipart\FormDataPart;
use Symfony\Component\Mime\Part\TextPart; 
use Symfony\Component\Mime\Part\HtmlPart;


class AuthController extends Controller
{
    public function login(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'password' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 500);
        }
        $user = User::where('email', $request->email)->first();
        if(!$user) return response()->json(['error' => 'User not found.'], 500);
        if (!(new BcryptHasher)->check($request->input('password'), $user->password)) {
            return response()->json(['error' => 'Email or password is incorrect. Authentication failed.'], 401);
        }
        $credentials = $request->only('email', 'password');
        try {
            JWTAuth::factory()->setTTL(40320); // Expired Time 28days
            if (! $token = JWTAuth::attempt($credentials, ['exp' => Carbon::now()->addDays(28)->timestamp])) {
                return response()->json(['error' => 'invalid_credentials'], 401);
            }
        } catch (JWTException $e) {
            return response()->json(['error' => 'could_not_create_token'], 500);
        }
        if($user->type == 'individual'){
            $individual = Individual::where('uid',$user->id)->first();
            return response()->json(['user' => $user,'individual'=>$individual,'token'=>$token,'status'=>200], 200);
        }else if($user->type =='salon'){
            $salon = Salon::where('uid',$user->id)->first();
            return response()->json(['user' => $user,'salon'=>$salon,'token'=>$token,'status'=>200], 200);
        }else{
            return response()->json(['user' => $user,'token'=>$token,'status'=>200], 200);
        }

    }

    public function userInfoAdmin(Request $request){
        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }

        $user = DB::table('users')->select('first_name','last_name','cover','email','country_code','mobile', 'venue_name', 'venue_address', 'phone_second', 'password_second')->where('id',$request->id)->first();
        $address = DB::table('address')->where('uid',$request->id)->get();
        $appointments = EventContract::where('user_id',$request->id)->orderBy('id','desc')->get();
        foreach($appointments as $loop){
            if($loop->freelancer_id == 0){
                $loop->salonInfo = Salon::where('uid',$loop->salon_id)->first();
                $loop->ownerInfo = User::select('mobile')->where('id',$loop->salon_id)->first();
            }else{
                $loop->individualInfo = DB::table('individual')
                ->select('individual.*','users.first_name as first_name','users.last_name as last_name')
                ->join('users','individual.uid','users.id')
                ->where('individual.uid',$loop->freelancer_id)
                ->first();
                $loop->ownerInfo = User::select('mobile')->where('id',$loop->freelancer_id)->first();
            }
        }

        $productsOrders = ProductOrders::where('uid',$request->id)->orderBy('id','desc')->get();
        foreach($productsOrders as $loop){
            if($loop->freelancer_id == 0){
                $loop->salonInfo = Salon::where('uid',$loop->salon_id)->first();
                $loop->ownerInfo = User::select('mobile')->where('id',$loop->salon_id)->first();
            }else{
                $loop->individualInfo = DB::table('individual')
                ->select('individual.*','users.first_name as first_name','users.last_name as last_name')
                ->join('users','individual.uid','users.id')
                ->where('individual.uid',$loop->freelancer_id)
                ->first();
                $loop->ownerInfo = User::select('mobile')->where('id',$loop->freelancer_id)->first();
            }
        }
        // foreach($productsOrders as $loop){
        //     $freelancerInfo  = User::select('id','first_name','last_name','cover','mobile','email')->where('id',$loop->freelancer_id)->first();
        //     if($loop->freelancer_id !=0){
        //         $loop->freelancerInfo = User::where('id',$loop->freelancer_id)->first();
        //     }else{
        //         $loop->freelancerInfo = User::where('id',$loop->salon_id)->first();
        //     }
        //     $loop->userInfo =User::where('id',$loop->uid)->first();
        // }
        $rating = DB::table('owner_reviews')->where('uid',$request->id)->get();
        foreach($rating as $loop){
            if($loop && $loop->freelancer_id && $loop->freelancer_id !=0){
                $loop->freelancerInfo = User::where('id',$loop->freelancer_id)->select('first_name','last_name','cover','email','country_code','mobile')->first();
            }
        }

        $ratingProducts = DB::table('product_reviews')->where('uid',$request->id)->get();
        foreach($ratingProducts as $loop){
            if($loop && $loop->product_id && $loop->product_id !=0){
                $loop->productInfo = Products::where('id',$loop->product_id)->first();
            }
        }
        $data = [
            'user'=>$user,
            'address'=>$address,
            'appointments'=>$appointments,
            'productsOrders'=>$productsOrders,
            'rating'=>$rating,
            'ratingProducts'=>$ratingProducts,
        ];
        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function get_admin(Request $request){
        $data = User::where('type','=','admin')->first();
        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }
        $response = [
            'data'=>true,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function create_user_account(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'first_name' => 'required',
            'last_name' => 'required',
            'mobile' => 'required',
            'country_code' => 'required',
            'password' => 'required',
            'extra_field' => 'required', // Add validation for the extra_field
        ]);
    
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', 
                'errors' => $validator->errors(),
                'status' => 500
            ];
            return response()->json($response, 500);
        }
    
        $emailValidation = User::where('email', $request->email)->first();
    
        if (is_null($emailValidation) || !$emailValidation) {
            $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];
            $data = User::where($matchThese)->first();
    
            if (is_null($data) || !$data) {
                $user = User::create([
                    'email' => $request->email,
                    'first_name' => $request->first_name,
                    'last_name' => $request->last_name,
                    'type' => 'user',
                    'status' => 1,
                    'mobile' => $request->mobile,
                    'cover' => 'NA',
                    'country_code' => $request->country_code,
                    'gender' => 1,
                    'password' => Hash::make($request->password),
                    'extra_field' => $request->extra_field, // Add the extra_field here
                    'venue_name' => $request->venue_name, 
                    'venue_address' => $request->venue_address,
                ]);
    
                $token = JWTAuth::fromUser($user);
    
                function clean($string) {
                    // ... (your existing clean function)
                }
    
                function generateRandomString($length = 10) {
                    // ... (your existing generateRandomString function)
                }
    
                $code = generateRandomString(13);
                $code = strtoupper($code);
                ReferralCodes::create(['uid' => $user->id, 'code' => $code]);
    
                return response()->json(['user' => $user, 'token' => $token, 'status' => 200], 200);
            }
    
            $response = [
                'success' => false,
                'message' => 'Mobile is already registered.',
                'status' => 500
            ];
            return response()->json($response, 500);
        }
    
        $response = [
            'success' => false,
            'message' => 'Email is already taken',
            'status' => 500
        ];
        return response()->json($response, 500);
    }
    
    public function create_admin_account(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'first_name'=>'required',
            'last_name'=>'required',
            'mobile'=>'required',
            'country_code'=>'required',
            'password' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 500);
        }
        $emailValidation = User::where('email',$request->email)->first();
        if (is_null($emailValidation) || !$emailValidation) {

            $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];
            $data = User::where($matchThese)->first();
            if (is_null($data) || !$data) {
                $checkExistOrNot = User::where('type','=','admin')->first();

                if (is_null($checkExistOrNot)) {
                    $user = User::create([
                        'email' => $request->email,
                        'first_name'=>$request->first_name,
                        'last_name'=>$request->last_name,
                        'type'=>'admin',
                        'status'=>1,
                        'mobile'=>$request->mobile,
                        'cover'=>'NA',
                        'country_code'=>$request->country_code,
                        'gender'=>1,
                        'password' => Hash::make($request->password),
                    ]);

                    $token = JWTAuth::fromUser($user);
                    return response()->json(['user'=>$user,'token'=>$token,'status'=>200], 200);
                }

                $response = [
                    'success' => false,
                    'message' => 'Account already setuped',
                    'status' => 500
                ];
                return response()->json($response, 500);
            }

            $response = [
                'success' => false,
                'message' => 'Mobile is already registered.',
                'status' => 500
            ];
            return response()->json($response, 500);
        }
        $response = [
            'success' => false,
            'message' => 'Email is already taken',
            'status' => 500
        ];
        return response()->json($response, 500);
    }

    public function adminLogin(Request $request){
        $user = User::where('email', $request->email)->first();

        if(!$user) return response()->json(['error' => 'User not found.'], 500);

        // Account Validation
        if (!(new BcryptHasher)->check($request->input('password'), $user->password)) {

            return response()->json(['error' => 'Email or password is incorrect. Authentication failed.'], 401);
        }

        if($user->type !='admin'){
            return response()->json(['error' => 'access denied'], 401);
        }
        // Login Attempt
        $credentials = $request->only('email', 'password');

        try {

            JWTAuth::factory()->setTTL(40320); // Expired Time 28days

            if (! $token = JWTAuth::attempt($credentials, ['exp' => Carbon::now()->addDays(28)->timestamp])) {

                return response()->json(['error' => 'invalid_credentials'], 401);

            }
        } catch (JWTException $e) {

            return response()->json(['error' => 'could_not_create_token'], 500);

        }
        return response()->json(['user' => $user,'token'=>$token,'status'=>200], 200);
    }

    public function uploadImage(Request $request){
        $validator = Validator::make($request->all(), [
            'image' => 'required|image:jpeg,png,jpg,gif,svg|max:2048'
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 505);
        }
        Artisan::call('storage:link', []);
        $uploadFolder = 'images';
        $image = $request->file('image');
        $image_uploaded_path = $image->store($uploadFolder, 'public');
        $uploadedImageResponse = array(
            "image_name" => basename($image_uploaded_path),
            "mime" => $image->getClientMimeType()
        );
        $response = [
            'data'=>$uploadedImageResponse,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function createSalonAccount(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'first_name'=>'required',
            'last_name'=>'required',
            'mobile'=>'required',
            'country_code'=>'required',
            'password' => 'required',
            'gender' => 'required',
            'cover' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 500);
        }
        $emailValidation = User::where('email',$request->email)->first();
        if (is_null($emailValidation) || !$emailValidation) {

            $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];
            $data = User::where($matchThese)->first();
            if (is_null($data) || !$data) {
                $user = User::create([
                    'email' => $request->email,
                    'first_name'=>$request->first_name,
                    'last_name'=>$request->last_name,
                    'type'=>'salon',
                    'status'=>1,
                    'mobile'=>$request->mobile,
                    'cover'=>$request->cover,
                    'country_code'=>$request->country_code,
                    'gender'=>$request->gender,
                    'password' => Hash::make($request->password),
                ]);
                return response()->json(['user'=>$user,'status'=>200], 200);
            }
            $response = [
                'success' => false,
                'message' => 'Mobile is already registered.',
                'status' => 500
            ];
            return response()->json($response, 500);
        }
        $response = [
            'success' => false,
            'message' => 'Email is already taken',
            'status' => 500
        ];
        return response()->json($response, 500);
    }

    public function createIndividualAccount(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'first_name'=>'required',
            'last_name'=>'required',
            'mobile'=>'required',
            'country_code'=>'required',
            'password' => 'required',
            'gender' => 'required',
            'cover' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 500);
        }
        $emailValidation = User::where('email',$request->email)->first();
        if (is_null($emailValidation) || !$emailValidation) {

            $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];
            $data = User::where($matchThese)->first();
            if (is_null($data) || !$data) {
                $user = User::create([
                    'email' => $request->email,
                    'first_name'=>$request->first_name,
                    'last_name'=>$request->last_name,
                    'type'=>'individual',
                    'status'=>1,
                    'mobile'=>$request->mobile,
                    'cover'=>$request->cover,
                    'country_code'=>$request->country_code,
                    'gender'=>$request->gender,
                    'password' => Hash::make($request->password),
                ]);
                return response()->json(['user'=>$user,'status'=>200], 200);
            }
            $response = [
                'success' => false,
                'message' => 'Mobile is already registered.',
                'status' => 500
            ];
            return response()->json($response, 500);
        }
        $response = [
            'success' => false,
            'message' => 'Email is already taken',
            'status' => 500
        ];
        return response()->json($response, 500);
    }

    public function getByID(Request $request){
        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $data = User::find($request->id);
        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }
        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getInfoForProductCart(Request $request){
        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $data = User::find($request->id);
        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }
        if($data->type =='individual'){
            // Individual
            $data->ownerInfo = Individual::where('uid',$request->id)->first();
        }else{
            // Salon
            $data->ownerInfo = Salon::where('uid',$request->id)->first();
        }
        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function update(Request $request){
        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $data = User::find($request->id)->update($request->all());
        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }
        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);

    }

    public function getOwnerInfo(Request $request){
        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $data = User::select('id','first_name','last_name','type')->where('id',$request->id)->first();
        if($data && $data->type =='individual'){
            $response = [
                'data'=>$data,
                'success' => true,
                'info'=>Individual::where('uid',$data->id)->first(),
                'status' => 200,
                'type'=>'individual'
            ];
            return response()->json($response, 200);
        }else{
            $response = [
                'data'=>$data,
                'success' => true,
                'info'=>Salon::where('uid',$data->id)->first(),
                'status' => 200,
                'type'=>'salon'
            ];
            return response()->json($response, 200);
        }
    }

    public function admins(){
        $data = User::where(['type'=>'admin'])->get();
        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }

        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function adminNewAdmin(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'first_name'=>'required',
            'last_name'=>'required',
            'mobile'=>'required',
            'country_code'=>'required',
            'password' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 500);
        }
        $emailValidation = User::where('email',$request->email)->first();
        if (is_null($emailValidation) || !$emailValidation) {

            $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];
            $data = User::where($matchThese)->first();
            if (is_null($data) || !$data) {
                $user = User::create([
                    'email' => $request->email,
                    'first_name'=>$request->first_name,
                    'last_name'=>$request->last_name,
                    'type'=>'admin',
                    'status'=>1,
                    'mobile'=>$request->mobile,
                    'lat'=>0,
                    'lng'=>0,
                    'cover'=>'NA',
                    'country_code'=>$request->country_code,
                    'password' => Hash::make($request->password),
                ]);

                $token = JWTAuth::fromUser($user);
                return response()->json(['user'=>$user,'token'=>$token,'status'=>200], 200);
            }

            $response = [
                'success' => false,
                'message' => 'Mobile is already registered.',
                'status' => 500
            ];
            return response()->json($response, 500);
        }
        $response = [
            'success' => false,
            'message' => 'Email is already taken',
            'status' => 500
        ];
        return response()->json($response, 500);
    }

    public function delete(Request $request){
        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $data = User::find($request->id);
        if ($data) {
            $data->delete();
            DB::table('address')->where('uid',$request->id)->delete();
            DB::table('appointments')->where('uid',$request->id)->delete();
            // DB::table('complaints')->where('uid',$request->id)->delete();
            // DB::table('conversions')->where('sender_id',$request->id)->delete();
            // DB::table('chat_rooms')->where('sender_id',$request->id)->delete();
            // DB::table('chat_rooms')->where('receiver_id',$request->id)->delete();
            // DB::table('complaints')->where('uid',$request->id)->delete();
            // DB::table('favourite')->where('uid',$request->id)->delete();
            // DB::table('freelancer_reviews')->where('uid',$request->id)->delete();
            DB::table('products_orders')->where('uid',$request->id)->delete();
            // DB::table('product_reviews')->where('uid',$request->id)->delete();
            $response = [
                'data'=>$data,
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

    public function getAllUsers(Request $request){
        $data = User::where('type','user')->orderBy('id','desc')->get();
        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

 public function sendMailToIndividual(Request $request)
{
    try {
        $validator = Validator::make($request->all(), [
            'subject' => 'required',
            'content' => 'required',
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation Error.',
                'errors' => $validator->errors(),
                'status' => 400
            ], 400);
        }

        $general = DB::table('settings')->select('name', 'email')->first();

        if (!$general) {
            return response()->json([
                'success' => false,
                'message' => 'General settings not found.',
                'status' => 500
            ], 500);
        }

        Mail::raw($request->content, function ($message) use ($request, $general) {
            $message->to($request->email)
                ->from($general->email, $general->name)
                ->subject($request->subject);
        });

        return response()->json([
            'success' => true,
            'message' => 'Email sent successfully',
            'status' => 200
        ], 200);

    } catch (Exception $e) {
        return response()->json([
            'success' => false,
            'message' => $e->getMessage(),
            'status' => 500
        ], 500);
    }
}


    public function sendMailToUsers( Request $request )
    {
        try {
            $validator = Validator::make($request->all(), [
                'subjects' => 'required',
                'content' => 'required',
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
            $users = User::select('email', 'first_name', 'last_name')->where('type', 1)->get();
            $general = DB::table('settings')->select('name', 'email')->first();
            foreach ($users as $user) {
                Mail::send([], [], function ($message) use ($request, $user, $general) {
                    $message->to($user->email)
                        ->from($general->email, $general->name)
                        ->subject($request->subjects)
                        ->setBody($request->content, 'text/html');
                });
            }

            $response = [
                'success' => true,
                'message' => 'success',
                'status' => 200
            ];
            return $response;

        } catch (Exception $e) {
            return response()->json($e->getMessage(), 200);
        }
    }

    public function sendMailToAll(Request $request){
        try {
            $validator = Validator::make($request->all(), [
                'subjects' => 'required',
                'content' => 'required',
            ]);
            if ($validator->fails()) {
                $response = [
                    'success' => false,
                    'message' => 'Validation Error.', $validator->errors(),
                    'status'=> 500
                ];
                return response()->json($response, 404);
            }
            $users = User::select('email','first_name','last_name')->get();
            $general  = DB::table('settings')->select('name','email')->first();
            foreach($users as $user){
                Mail::send([], [], function ($message) use ($request,$user,$general) {
                    $message->to($user->email)
                      ->from($general->email, $general->name)
                      ->subject($request->subjects)
                      ->setBody($request->content, 'text/html');
                  });
            }

            $response = [
                'success' => true,
                'message' => 'success',
                'status' => 200
            ];
            return $response;

        } catch (Exception $e) {
            return response()->json($e->getMessage(),200);
        }
    }

    public function sendMailToStores(Request $request){
        try {
            $validator = Validator::make($request->all(), [
                'subjects' => 'required',
                'content' => 'required',
            ]);
            if ($validator->fails()) {
                $response = [
                    'success' => false,
                    'message' => 'Validation Error.', $validator->errors(),
                    'status'=> 500
                ];
                return response()->json($response, 404);
            }
            $users = User::select('email','first_name','last_name')->where('type','freelancer')->get();
            $general  = DB::table('settings')->select('name','email')->first();
            foreach($users as $user){
                Mail::send([], [], function ($message) use ($request,$user,$general) {
                    $message->to($user->email)
                      ->from($general->email, $general->name)
                      ->subject($request->subjects)
                      ->setBody($request->content, 'text/html');
                  });
            }

            $response = [
                'success' => true,
                'message' => 'success',
                'status' => 200
            ];
            return $response;

        } catch (Exception $e) {
            return response()->json($e->getMessage(),200);
        }
    }

    public function sendMailToSalon(Request $request){
        try {
            $validator = Validator::make($request->all(), [
                'subjects' => 'required',
                'content' => 'required',
            ]);
            if ($validator->fails()) {
                $response = [
                    'success' => false,
                    'message' => 'Validation Error.', $validator->errors(),
                    'status'=> 500
                ];
                return response()->json($response, 404);
            }
            $users = User::select('email','first_name','last_name')->where('type','salon')->get();
            $general  = DB::table('settings')->select('name','email')->first();
            foreach($users as $user){
                Mail::send([], [], function ($message) use ($request,$user,$general) {
                    $message->to($user->email)
                      ->from($general->email, $general->name)
                      ->subject($request->subjects)
                      ->setBody($request->content, 'text/html');
                  });
            }

            $response = [
                'success' => true,
                'message' => 'success',
                'status' => 200
            ];
            return $response;

        } catch (Exception $e) {
            return response()->json($e->getMessage(),200);
        }
    }

    public function logout(){
        // Invalidate current logged user token
        auth()->logout();

        // Return message
        return response()
            ->json(['message' => 'Successfully logged out']);
    }

    public function firebaseauth(Request $request){
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $url = url('/api/v1/success_verified');
        return view('fireauth',['mobile'=>$request->mobile,'redirect'=>$url]);
    }

    public function sendVerificationOnMail(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'country_code'=>'required',
            'mobile'=>'required'
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }

        $data = User::where('email',$request->email)->first();
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];
        $data2 = User::where($matchThese)->first();
        if (is_null($data) && is_null($data2)) {
            $settings = Settings::take(1)->first();
            $generalInfo = Settings::take(1)->first();
            $mail = $request->email;
            $username = $request->email;
            $subject = $request->subject;
            $otp = random_int(100000, 999999);
            $savedOTP = Otp::create([
                'otp'=>$otp,
                'email'=>$request->email,
                'status'=>0,
            ]);
            $mailTo = Mail::send('mails/register',
                [
                    'app_name'      =>$generalInfo->name,
                    'otp'          => $otp
                ]
                , function($message) use($mail,$username,$subject,$generalInfo){
                $message->to($mail, $username)
                ->subject($subject);
                $message->from($generalInfo->email,$generalInfo->name);
            });

            $response = [
                'data'=>true,
                'mail'=>$mailTo,
                'otp_id'=>$savedOTP->id,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        }

        $response = [
            'data' => false,
            'message' => 'email or mobile is already registered',
            'status' => 500
        ];
        return response()->json($response, 200);
    }

    public function verifyPhoneForFirebaseRegistrations(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'country_code'=>'required',
            'mobile'=>'required'
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }

        $data = User::where('email',$request->email)->first();
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];
        $data2 = User::where($matchThese)->first();
        if (is_null($data) && is_null($data2)) {
            $response = [
                'data'=>true,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        }

        $response = [
            'data' => false,
            'message' => 'email or mobile is already registered',
            'status' => 500
        ];
        return response()->json($response, 200);
    }

    public function verifyPhoneSignup(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'country_code'=>'required',
            'mobile'=>'required'
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }

        $data = User::where('email',$request->email)->first();
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];
        $data2 = User::where($matchThese)->first();
        if (is_null($data) && is_null($data2)) {
            $settings = Settings::take(1)->first();
            if($settings->sms_name =='0'){ // send with twillo
                $payCreds = DB::table('settings')
                ->select('*')->first();
                if (is_null($payCreds) || is_null($payCreds->sms_creds)) {
                    $response = [
                        'success' => false,
                        'message' => 'sms gateway issue please contact administrator',
                        'status' => 404
                    ];
                    return response()->json($response, 404);
                }
                $credsData = json_decode($payCreds->sms_creds);
                if(is_null($credsData) || is_null($credsData->twilloCreds) || is_null($credsData->twilloCreds->sid)){
                    $response = [
                        'success' => false,
                        'message' => 'sms gateway issue please contact administrator',
                        'status' => 404
                    ];
                    return response()->json($response, 404);
                }

                $id = $credsData->twilloCreds->sid;
                $token = $credsData->twilloCreds->token;
                $url = "https://api.twilio.com/2010-04-01/Accounts/$id/Messages.json";
                $from = $credsData->twilloCreds->from;
                $to = $request->country_code.$request->mobile; // twilio trial verified number
                try{
                    $otp = random_int(100000, 999999);
                    $client = new \GuzzleHttp\Client();
                    $response = $client->request('POST', $url, [
                        'headers' =>
                        [
                            'Accept' => 'application/json',
                            'Content-Type' => 'application/x-www-form-urlencoded',
                        ],
                        'form_params' => [
                        'Body' => 'Your Verification code is : '.$otp, //set message body
                        'To' => $to,
                        'From' => $from //we get this number from twilio
                        ],
                        'auth' => [$id, $token, 'basic']
                        ]
                    );
                    $savedOTP = Otp::create([
                        'otp'=>$otp,
                        'email'=>$to,
                        'status'=>0,
                    ]);
                    $response = [
                        'data'=>true,
                        'otp_id'=>$savedOTP->id,
                        'success' => true,
                        'status' => 200,
                    ];
                    return response()->json($response, 200);
                }catch (Exception $e){
                    echo "Error: " . $e->getMessage();
                }

            }else{ // send with msg91
                $payCreds = DB::table('settings')
                ->select('*')->first();
                if (is_null($payCreds) || is_null($payCreds->sms_creds)) {
                    $response = [
                        'success' => false,
                        'message' => 'sms gateway issue please contact administrator',
                        'status' => 404
                    ];
                    return response()->json($response, 404);
                }
                $credsData = json_decode($payCreds->sms_creds);
                if(is_null($credsData) || is_null($credsData->msg) || is_null($credsData->msg->key)){
                    $response = [
                        'success' => false,
                        'message' => 'sms gateway issue please contact administrator',
                        'status' => 404
                    ];
                    return response()->json($response, 404);
                }
                $clientId = $credsData->msg->key;
                $smsSender = $credsData->msg->sender;
                $otp = random_int(100000, 999999);
                $client = new \GuzzleHttp\Client();
                $to = $request->country_code.$request->mobile;
                $res = $client->get('http://api.msg91.com/api/sendotp.php?authkey='.$clientId.'&message=Your Verification code is : '.$otp.'&mobile='.$to.'&sender='.$smsSender.'&otp='.$otp);
                $data = json_decode($res->getBody()->getContents());
                $savedOTP = Otp::create([
                    'otp'=>$otp,
                    'email'=>$to,
                    'status'=>0,
                ]);
                $response = [
                    'data'=>true,
                    'otp_id'=>$savedOTP->id,
                    'success' => true,
                    'status' => 200,
                ];
                return response()->json($response, 200);
            }
        }

        $response = [
            'data' => false,
            'message' => 'email or mobile is already registered',
            'status' => 500
        ];
        return response()->json($response, 200);
    }

    public function getMyWalletBalance(Request $request){
        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $data = User::find($request->id);
        $data['balance'] = $data->balance;
        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getMyWallet(Request $request){
        // $data = Auth::user();
        $validator = Validator::make($request->all(), [
            'id' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $data = User::find($request->id);
        $data['balance'] = $data->balance;

        $transactions = DB::table('transactions')
        ->select('amount','uuid','type','created_at','updated_at')
        ->where('payable_id',$request->id)
        ->get();
        $response = [
            'data'=>$data,
            'transactions'=>$transactions,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function loginWithPhonePassword(Request $request){
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
            'country_code'=>'required',
            'password'=>'required'
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];

        $user = User::where($matchThese)->first();

        if(!$user) return response()->json(['error' => 'User not found.'], 500);

        // Account Validation
        if (!(new BcryptHasher)->check($request->input('password'), $user->password)) {

            return response()->json(['error' => 'Phone Number or password is incorrect. Authentication failed.'], 401);
        }

        // Login Attempt
        $credentials = $request->only('country_code','mobile', 'password');

        try {

            JWTAuth::factory()->setTTL(40320); // Expired Time 28days

            if (! $token = JWTAuth::attempt($credentials, ['exp' => Carbon::now()->addDays(28)->timestamp])) {

                return response()->json(['error' => 'invalid_credentials'], 401);

            }
        } catch (JWTException $e) {

            return response()->json(['error' => 'could_not_create_token'], 500);

        }
        if($user->type == 'individual'){
            $individual = Individual::where('uid',$user->id)->first();
            return response()->json(['user' => $user,'individual'=>$individual,'token'=>$token,'status'=>200], 200);
        }else if($user->type =='salon'){
            $salon = Salon::where('uid',$user->id)->first();
            return response()->json(['user' => $user,'salon'=>$salon,'token'=>$token,'status'=>200], 200);
        }else{
            return response()->json(['user' => $user,'token'=>$token,'status'=>200], 200);
        }
    }

    public function verifyPhoneForFirebase(Request $request){
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
            'country_code'=>'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];

        $user = User::where($matchThese)->first();

        if(!$user) return response()->json(['data'=>false,'error' => 'User not found.'], 500);
        $response = [
            'data'=>true,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function loginWithMobileOtp(Request $request){
        $validator = Validator::make($request->all(), [
            'mobile' => 'required',
            'country_code'=>'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];

        $user = User::where($matchThese)->first();

        if(!$user) return response()->json(['error' => 'User not found.'], 500);

        try {

            JWTAuth::factory()->setTTL(40320); // Expired Time 28days

            if (! $token = JWTAuth::fromUser($user, ['exp' => Carbon::now()->addDays(28)->timestamp])) {

                return response()->json(['error' => 'invalid_credentials'], 401);

            }
        } catch (JWTException $e) {

            return response()->json(['error' => 'could_not_create_token'], 500);

        }
        if($user->type == 'individual'){
            $individual = Individual::where('uid',$user->id)->first();
            return response()->json(['user' => $user,'individual'=>$individual,'token'=>$token,'status'=>200], 200);
        }else if($user->type =='salon'){
            $salon = Salon::where('uid',$user->id)->first();
            return response()->json(['user' => $user,'salon'=>$salon,'token'=>$token,'status'=>200], 200);
        }else{
            return response()->json(['user' => $user,'token'=>$token,'status'=>200], 200);
        }
    }

    public function verifyEmailForReset(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $matchThese = ['email' => $request->email];

        $user = User::where($matchThese)->first();

        if(!$user) return response()->json(['data'=>false,'error' => 'User not found.'], 500);

        $settings = Settings::take(1)->first();
        $mail = $request->email;
        $username = $request->email;
        $subject = 'Reset Password';
        $otp = random_int(100000, 999999);
        $savedOTP = Otp::create([
            'otp'=>$otp,
            'email'=>$request->email,
            'status'=>0,
        ]);
        $mailTo = Mail::send('mails/reset',
            [
                'app_name'      =>$settings->name,
                'otp'          => $otp
            ]
            , function($message) use($mail,$username,$subject,$settings){
            $message->to($mail, $username)
            ->subject($subject);
            $message->from($settings->email,$settings->name);
        });

        $response = [
            'data'=>true,
            'mail'=>$mailTo,
            'otp_id'=>$savedOTP->id,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);

    }

    public function updateUserPasswordWithEmail(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'password' => 'required',
            //'password_second' => 'required', // Ensure password_second is required
            'id' => 'required',
        ]);

        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.',
                'errors' => $validator->errors(), // Include errors in the response
                'status'=> 400 // Return 400 Bad Request for validation errors
            ];
            return response()->json($response, 400);
        }

        $match =  ['email'=>$request->email,'id'=>$request->id];
        $data = Otp::where($match)->first();

        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }

        // Update both password and password_second
        $updates = User::where('email', $request->email)->first();
        $updates->update([
            'password' => Hash::make($request->password), // Hash the password
            'password_second' => $request->password_second // Assign password_second directly
        ]);

        $response = [
            'data' => true,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }


    public function verifyEmail(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 500);
        }
        $emailValidation = User::where('email',$request->email)->first();
        if (is_null($emailValidation) || !$emailValidation) {
            $settings = Settings::take(1)->first();
            $mail = $request->email;
            $username = $request->email;
            $subject = 'Reset Password';
            $otp = random_int(100000, 999999);
            $savedOTP = Otp::create([
                'otp'=>$otp,
                'email'=>$request->email,
                'status'=>0,
            ]);
            $mailTo = Mail::send('mails/register',
                [
                    'app_name'      =>$settings->name,
                    'otp'          => $otp
                ]
                , function($message) use($mail,$username,$subject,$settings){
                $message->to($mail, $username)
                ->subject($subject);
                $message->from($settings->email,$settings->name);
            });

            $response = [
                'data'=>true,
                'mail'=>$mailTo,
                'otp_id'=>$savedOTP->id,
                'success' => true,
                'status' => 200,
            ];
            return response()->json($response, 200);
        }
        $response = [
            'success' => false,
            'message' => 'Email is already taken',
            'status' => 500
        ];
        return response()->json($response, 500);
    }

    public function verifyPhone(Request $request){
        $validator = Validator::make($request->all(), [
            'mobile'=>'required',
            'country_code'=>'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 500);
        }
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];
        $data = User::where($matchThese)->first();
        if (is_null($data) || !$data) {
            $settings = Settings::take(1)->first();
            if($settings->sms_name =='0'){ // send with twillo
                $payCreds = DB::table('settings')
                ->select('*')->first();
                if (is_null($payCreds) || is_null($payCreds->sms_creds)) {
                    $response = [
                        'success' => false,
                        'message' => 'sms gateway issue please contact administrator',
                        'status' => 404
                    ];
                    return response()->json($response, 404);
                }
                $credsData = json_decode($payCreds->sms_creds);
                if(is_null($credsData) || is_null($credsData->twilloCreds) || is_null($credsData->twilloCreds->sid)){
                    $response = [
                        'success' => false,
                        'message' => 'sms gateway issue please contact administrator',
                        'status' => 404
                    ];
                    return response()->json($response, 404);
                }

                $id = $credsData->twilloCreds->sid;
                $token = $credsData->twilloCreds->token;
                $url = "https://api.twilio.com/2010-04-01/Accounts/$id/Messages.json";
                $from = $credsData->twilloCreds->from;
                $to = $request->country_code.$request->mobile; // twilio trial verified number
                try{
                    $otp = random_int(100000, 999999);
                    $client = new \GuzzleHttp\Client();
                    $response = $client->request('POST', $url, [
                        'headers' =>
                        [
                            'Accept' => 'application/json',
                            'Content-Type' => 'application/x-www-form-urlencoded',
                        ],
                        'form_params' => [
                        'Body' => 'Your Verification code is : '.$otp, //set message body
                        'To' => $to,
                        'From' => $from //we get this number from twilio
                        ],
                        'auth' => [$id, $token, 'basic']
                        ]
                    );
                    $savedOTP = Otp::create([
                        'otp'=>$otp,
                        'email'=>$to,
                        'status'=>0,
                    ]);
                    $response = [
                        'data'=>true,
                        'otp_id'=>$savedOTP->id,
                        'success' => true,
                        'status' => 200,
                    ];
                    return response()->json($response, 200);
                }catch (Exception $e){
                    echo "Error: " . $e->getMessage();
                }

            }else{ // send with msg91
                $payCreds = DB::table('settings')
                ->select('*')->first();
                if (is_null($payCreds) || is_null($payCreds->sms_creds)) {
                    $response = [
                        'success' => false,
                        'message' => 'sms gateway issue please contact administrator',
                        'status' => 404
                    ];
                    return response()->json($response, 404);
                }
                $credsData = json_decode($payCreds->sms_creds);
                if(is_null($credsData) || is_null($credsData->msg) || is_null($credsData->msg->key)){
                    $response = [
                        'success' => false,
                        'message' => 'sms gateway issue please contact administrator',
                        'status' => 404
                    ];
                    return response()->json($response, 404);
                }
                $clientId = $credsData->msg->key;
                $smsSender = $credsData->msg->sender;
                $otp = random_int(100000, 999999);
                $client = new \GuzzleHttp\Client();
                $to = $request->country_code.$request->mobile;
                $res = $client->get('http://api.msg91.com/api/sendotp.php?authkey='.$clientId.'&message=Your Verification code is : '.$otp.'&mobile='.$to.'&sender='.$smsSender.'&otp='.$otp);
                $data = json_decode($res->getBody()->getContents());
                $savedOTP = Otp::create([
                    'otp'=>$otp,
                    'email'=>$to,
                    'status'=>0,
                ]);
                $response = [
                    'data'=>true,
                    'otp_id'=>$savedOTP->id,
                    'success' => true,
                    'status' => 200,
                ];
                return response()->json($response, 200);
            }
        }
        $response = [
            'success' => false,
            'message' => 'Mobile is already registered.',
            'status' => 500
        ];
        return response()->json($response, 500);
    }

    public function checkPhoneExist(Request $request){
        $validator = Validator::make($request->all(), [
            'mobile'=>'required',
            'country_code'=>'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 500);
        }
        $matchThese = ['country_code' => $request->country_code, 'mobile' => $request->mobile];
        $data = User::where($matchThese)->first();
        if (is_null($data) || !$data) {
            $response = [
                'data' => true,
                'message' => 'Ok',
                'status' => 200
            ];
            return response()->json($response, 200);
        }
        $response = [
            'success' => false,
            'message' => 'Mobile is already registered.',
            'status' => 500
        ];
        return response()->json($response, 500);
    }

    public function getAdminHome(Request $request){

        $productsOrders = ProductOrders::limit(10)->orderBy('id','desc')->get();
        foreach($productsOrders as $loop){
            $loop->userInfo = User::where('id',$loop->uid)->first();
            if($loop->freelancer_id == 0){
                $loop->salonInfo = Salon::where('uid',$loop->salon_id)->first();
            }else{
                $loop->individualInfo = DB::table('individual')
                ->select('individual.*','users.first_name as first_name','users.last_name as last_name')
                ->join('users','individual.uid','users.id')
                ->where('individual.uid',$loop->freelancer_id)
                ->first();
            }
            // $freelancerInfo  = User::select('id','first_name','last_name','cover','mobile','email')->where('id',$loop->freelancer_id)->first();
            // $loop->freelancerInfo =$freelancerInfo;
            // $loop->userInfo =User::where('id',$loop->uid)->first();
        }
        $recentUser = User::where('type','user')->limit(10)->orderBy('id','desc')->get();
        $complaints = Complaints::whereMonth('created_at', Carbon::now()->month)->get();
        foreach($complaints as $loop){
            $user = User::select('email','first_name','last_name','cover')->where('id',$loop->uid)->first();
            $loop->userInfo = $user;
            if($loop && $loop->freelancer_id && $loop->freelancer_id !=null){
                $owner = User::select('type')->where('id',$loop->freelancer_id)->first();
                if($owner == 'salon'){
                    $store = Salon::select('name','cover')->where('uid',$loop->freelancer_id)->first();
                }else{
                    $store = User::select(DB::raw('CONCAT(last_name, first_name) AS name'),'cover')->where('id',$loop->freelancer_id)->first();
                }
                $storeUser = User::select('email','cover')->where('id',$loop->freelancer_id)->first();
                $loop->storeInfo = $store;
                $loop->storeUiserInfo = $storeUser;
            }

            if($loop && $loop->driver_id && $loop->driver_id !=null){
                $driver = User::select('email','first_name','last_name','cover')->where('id',$loop->driver_id)->first();
                $loop->driverInfo = $driver;
            }

            if($loop && $loop->product_id && $loop->product_id !=null){
                $product = Products::select('name','cover')->where('id',$loop->product_id)->first();
                $loop->productInfo = $product;
            }

            if($loop && $loop->complaints_on == 0 && $loop->product_id && $loop->product_id !=null){
                $product = Services::select('name','cover')->where('id',$loop->product_id)->first();
                $loop->productInfo = $product;
            }

            if($loop && $loop->complaints_on == 0 && $loop->product_id && $loop->product_id !=null){
                $product = Packages::select('name','cover')->where('id',$loop->product_id)->first();
                $loop->productInfo = $product;
            }

        }

        $appointments = EventContract::limit(10)->orderBy('id','desc')->get();
        foreach($appointments as $loop){
            $loop->userInfo = User::where('id',$loop->uid)->first();
            if($loop->individual_id == 0){
                $loop->salonInfo = Salon::where('uid',$loop->salon_id)->first();
            }else{
                $loop->individualInfo = DB::table('individual')
                ->select('individual.*','users.first_name as first_name','users.last_name as last_name')
                ->join('users','individual.uid','users.id')
                ->where('individual.uid',$loop->individual_id)
                ->first();
            }
        }

        $now = Carbon::now();
        $todatData = EventContract::select(\DB::raw("COUNT(*) as count"), \DB::raw("DATE_FORMAT(date,'%h:%m') as day_name"), \DB::raw("DATE_FORMAT(date,'%h:%m') as day"))
        ->whereDate('date',Carbon::today())
        ->groupBy('day_name','day')
        ->orderBy('day')
        ->get();
        $weekData = EventContract::select(\DB::raw("COUNT(*) as count"), \DB::raw("DATE(date) as day_name"), \DB::raw("DATE(date) as day"))
            ->whereBetween('date', [Carbon::now()->startOfWeek(), Carbon::now()->endOfWeek()])
            ->groupBy('day_name','day')
            ->orderBy('day')
            ->get();
        $monthData = EventContract::select(\DB::raw("COUNT(*) as count"), \DB::raw("DATE(date) as day_name"), \DB::raw("DATE(date) as day"))
            ->whereMonth('date', Carbon::now()->month)
            ->groupBy('day_name','day')
            ->orderBy('day')
            ->get();
        $monthResponse = [];
        $weekResponse =[];
        $todayResponse = [];
        foreach($todatData as $row) {
            $todayResponse['label'][] = $row->day_name;
            $todayResponse['data'][] = (int) $row->count;
        }
        foreach($weekData as $row) {
            $weekResponse['label'][] = $row->day_name;
            $weekResponse['data'][] = (int) $row->count;
        }
        foreach($monthData as $row) {
            $monthResponse['label'][] = $row->day_name;
            $monthResponse['data'][] = (int) $row->count;
        }
        $todayDate  = $now->format('d F');
        $weekStartDate = $now->startOfWeek()->format('d');
        $weekEndDate = $now->endOfWeek()->format('d F');
        $monthStartDate = $now->startOfMonth()->format('d');
        $monthEndDate = $now->endOfMonth()->format('d F');

        /////////////////////////////////////////////////// product orders ////////////////////////////////////////////////////////////////////

        $todatDataProducts = ProductOrders::select(\DB::raw("COUNT(*) as count"), \DB::raw("DATE_FORMAT(date_time,'%h:%m') as day_name"), \DB::raw("DATE_FORMAT(date_time,'%h:%m') as day"))
        ->whereDate('date_time',Carbon::today())
        ->groupBy('day_name','day')
        ->orderBy('day')
        ->get();
        $weekDataProducts = ProductOrders::select(\DB::raw("COUNT(*) as count"), \DB::raw("DATE(date_time) as day_name"), \DB::raw("DATE(date_time) as day"))
            ->whereBetween('date_time', [Carbon::now()->startOfWeek(), Carbon::now()->endOfWeek()])
            ->groupBy('day_name','day')
            ->orderBy('day')
            ->get();
        $monthDataProducts = ProductOrders::select(\DB::raw("COUNT(*) as count"), \DB::raw("DATE(date_time) as day_name"), \DB::raw("DATE(date_time) as day"))
            ->whereMonth('date_time', Carbon::now()->month)
            ->groupBy('day_name','day')
            ->orderBy('day')
            ->get();
        $monthResponseProducts = [];
        $weekResponseProducts =[];
        $todayResponseProducts = [];
        foreach($todatDataProducts as $row) {
            $todayResponseProducts['label'][] = $row->day_name;
            $todayResponseProducts['data'][] = (int) $row->count;
        }
        foreach($weekDataProducts as $row) {
            $weekResponseProducts['label'][] = $row->day_name;
            $weekResponseProducts['data'][] = (int) $row->count;
        }
        foreach($monthDataProducts as $row) {
            $monthResponseProducts['label'][] = $row->day_name;
            $monthResponseProducts['data'][] = (int) $row->count;
        }
        $todayDateProducts  = $now->format('d F');
        $weekStartDateProducts = $now->startOfWeek()->format('d');
        $weekEndDateProducts = $now->endOfWeek()->format('d F');
        $monthStartDateProducts = $now->startOfMonth()->format('d');
        $monthEndDateProducts = $now->endOfMonth()->format('d F');
        /////////////////////////////////////////////////// product orders ////////////////////////////////////////////////////////////////////

        $response = [
            'today' => $todayResponse,
            'week' => $weekResponse,
            'month' => $monthResponse,
            'todayLabel' => $todayDate,
            'weekLabel' => $weekStartDate . '-'. $weekEndDate,
            'monthLabel' => $monthStartDate.'-'.$monthEndDate,

            'todayProducts' => $todayResponseProducts,
            'weekProducts' => $weekResponseProducts,
            'monthProducts' => $monthResponseProducts,
            'todayLabelProducts' => $todayDateProducts,
            'weekLabelProducts' => $weekStartDateProducts . '-'. $weekEndDateProducts,
            'monthLabelProducts' => $monthStartDateProducts.'-'.$monthEndDateProducts,

            'productsOrders'=>$productsOrders,
            'appointments'=>$appointments,
            'total_freelancers'=>Individual::count(),
            'total_salon'=>Salon::count(),
            'total_users'=>User::where('type','user')->count(),
            'user'=>$recentUser,
            'total_orders'=>ProductOrders::count(),
            'total_products'=>Products::count(),
            'total_appointments'=>EventContract::where('salon_id','!=',0)->count(),
            'total_appointments_freelancer'=>EventContract::where('individual_id','!=',0)->count(),
            'complaints'=>$complaints,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getFavoriteData( Request $request )
    {
        $validator = Validator::make($request->all(), [
            'lat' => 'required',
            'lng' => 'required',
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
        $searchQuery = Settings::select('allowDistance', 'searchResultKind')->first();
        if ($searchQuery->searchResultKind == 1) {
            $values = 3959; // miles
            $distanceType = 'miles';
        } else {
            $values = 6371; // km
            $distanceType = 'km';
        }

        $userInfo = Auth::user();
        // Retrieve individuals of a user
        $individuals = $userInfo->individuals;

        // Retrieve salons of a user
        $salons = $userInfo->salons;

        $salon = Salon::select(DB::raw('salon.id as id,salon.uid as uid,salon.name as name,salon.rating as rating,
        salon.total_rating as total_rating,salon.address as address,salon.cover as cover,salon.lat as salon_lat,salon.lng as salon_lng, ( ' . $values . ' * acos( cos( radians(' . $request->lat . ') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(' . $request->lng . ') ) + sin( radians(' . $request->lat . ') ) * sin( radians( lat ) ) ) ) AS distance'))
            ->having('distance', '<', (int) $searchQuery->allowDistance)
            ->orderBy('distance')
            ->where(['salon.status' => 1, 'salon.in_home' => 1])
            ->whereIn('salon.id', $salons->pluck('id'))
            ->get();

        $freelancer = Individual::select(DB::raw('individual.id as id,individual.uid as uid,individual.lat as lat,individual.lng as lng, ( ' . $values . ' * acos( cos( radians(' . $request->lat . ') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(' . $request->lng . ') ) + sin( radians(' . $request->lat . ') ) * sin( radians( lat ) ) ) ) AS distance'))
            ->having('distance', '<', (int) $searchQuery->allowDistance)
            ->orderBy('distance')
            ->where(['individual.status' => 1, 'individual.in_home' => 1])
            ->whereIn('individual.id', $individuals->pluck('id'))
            ->get();
        foreach ($freelancer as $loop) {
            $loop->userInfo = User::select('first_name', 'last_name', 'cover')->find($loop->uid);
        }

        $cities = Cities::select(DB::raw('cities.id as id,cities.name as name, ( ' . $values . ' * acos( cos( radians(' . $request->lat . ') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(' . $request->lng . ') ) + sin( radians(' . $request->lat . ') ) * sin( radians( lat ) ) ) ) AS distance'))
            ->having('distance', '<', (int) $searchQuery->allowDistance)
            ->orderBy('distance')
            ->where(['cities.status' => 1])
            ->first();
        $banners = [];
        if (isset($cities) && $cities) {
            $banners = Banners::where('city_id', $cities->id)->get();
        }
        $salonUID = $salon->pluck('uid')->toArray();
        $freelancerUID = $freelancer->pluck('uid')->toArray();
        $uidArray = Arr::collapse([$salonUID, $freelancerUID]);
        $products = Products::where('in_home', 1)->WhereIn('freelacer_id', $uidArray)->limit(10)->get();
        $categories = Category::where(['status' => 1])->get();
        $response = [
            'salon' => $salon,
            'categories' => $categories,
            'individual' => $freelancer,
            'cities' => $cities,
            'banners' => $banners,
            'products' => $products,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

     public function updateFavoriteIndividual( Request $request )
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
            'is_favorite' => 'required',
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
        
        $userInfo = Auth::user();
        // Add an individual to a user
        if ($request->is_favorite == 0) {
            $userInfo->individuals()->attach($request->id);
        } else if ($request->is_favorite == 1) {
            $userInfo->individuals()->detach($request->id);
        }
        $response = [
            'data' => true,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function updateFavoriteSalon( Request $request )
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
            'is_favorite' => 'required',
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
        
        $userInfo = Auth::user();
        // Add an Salon to a user
        if ($request->is_favorite == 0) {
            $userInfo->Salons()->attach($request->id);
        } else if ($request->is_favorite == 1) {
            $userInfo->Salons()->detach($request->id);
        }
        $response = [
            'data' => true,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }
    public function deleteFavoriteIndividual(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
            'is_favorite' => 'required',
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

        $userInfo = Auth::user();
        // Remove an individual from a user
        $userInfo->individuals()->detach($request->id);

        $response = [
            'data' => true,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }
    
    public function deleteFavoriteSalon(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'id' => 'required',
            'is_favorite' => 'required',
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

        $userInfo = Auth::user();
        // Remove a salon from a user
        $userInfo->Salons()->detach($request->id);

        $response = [
            'data' => true,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }
}
