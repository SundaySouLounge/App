<?php

namespace App\Http\Controllers\v1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Salon;
use App\Models\Banners;
use App\Models\Category;
use App\Models\User;
use App\Models\Cities;
use App\Models\Settings;
use App\Models\Individual;
use App\Models\Services;
use App\Models\Specialist;
use App\Models\Packages;
use App\Models\Commission;
use App\Models\Products;
use App\Models\UnavailableDate;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;
use Validator;
use DB;
use Doctrine\DBAL\Query;
use Exception;
use Faker\Calculator\Ean;

class SalonController extends Controller
{
    public function save(Request $request){
        $validator = Validator::make($request->all(), [
            'uid' => 'required',
            'name' => 'required',
            'cover' => 'required',
            'categories' => 'required',
            'address' => 'required',
            'lat' => 'required',
            'lng' => 'required',
            'about' => 'required',
            'rating' => 'required',
            'total_rating' => 'required',
            'website' => 'required',
            'timing' => 'required',
            'images' => 'required',
            'zipcode' => 'required',
            'service_at_home' => 'required',
            'verified' => 'required',
            'status' => 'required',
            'have_stylist'=>'required',
            'in_home'=>'required',
            'popular'=>'required',
            'have_shop'=>'required',
            'rate' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }

        $data = Salon::create($request->all());
        if (is_null($data)) {
            $response = [
            'data'=>$data,
            'message' => 'error',
            'status' => 500,
        ];
        return response()->json($response, 200);
        }
        Commission::create([
            'uid'=>$request->uid,
            'rate'=>$request->rate,
            'status'=>1,
        ]);
        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getByUID(Request $request){
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

        $data = Salon::where('uid',$request->id)->first();
        if($data && $data->categories && $data->categories !=null){
            $ids = explode(',',$data->categories);
            $cats = Category::WhereIn('id',$ids)->get();
            $data->web_cates_data = $cats;
        }
        if($data && $data->cid && $data->cid !=null){
            $data->city_data = Cities::find($data->cid);
        }
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

    public function getSearchResult(Request $request){
        $str = "";
        $solo = 0;
        $duo = 0;
        $trio = 0;
        $quartet = 0;
        $date = date("Y-m-d");

        if ($request->has('param') && $request->has('lat') && $request->has('lng')) {
            $str = $request->param;
            $solo = $request->solo;
            $duo = $request->duo;
            $trio = $request->trio;
            $quartet = $request->quarter;
            $date = isset($request->date) ? Carbon::parse($request->date)->format('Y-m-d') : $date;
            $lat = $request->lat;
            $lng = $request->lng;
        }
        $searchQuery = Settings::select('allowDistance','searchResultKind')->first();
        $categories = Category::where(['status'=>1])->get();
        if($searchQuery->searchResultKind == 1){
            $values = 3959; // miles
            $distanceType = 'miles';
        }else{
            $values = 6371; // km
            $distanceType = 'km';
        }

        // DJs.
        $salon_ids = UnavailableDate::select('salon_id')
        ->where('unavailable_date', '=', $date)
        ->whereNotNull('salon_id')
        ->distinct()->pluck('salon_id')->toArray();

        $salon = Salon::select(DB::raw('salon.id as id,salon.uid as uid,salon.name as name,salon.rating as rating,
        salon.total_rating as total_rating,salon.address as address,salon.cover as cover,salon.lat as salon_lat,salon.lng as salon_lng, ( '.$values.' * acos( cos( radians('.$lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$lng.') ) + sin( radians('.$lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where('salon.name', 'like', '%'.$str.'%')
        // ->where(['salon.in_home' => $solo, 'salon.have_stylist' => $duo, 'salon.service_at_home' => $trio])
        ->where(function ($query) use ($solo, $duo, $trio) {
            if($solo) {
                $query->orWhere('salon.in_home', '=', $solo);
            }
            if($duo) {
                $query->orWhere('salon.have_stylist', '=', $duo);
            }
            if($trio) {
                $query->orWhere('salon.service_at_home', '=', $trio);
            }
        })
        ->where('salon.status', 1)
        ->whereNotIn('salon.id', $salon_ids)
        ->get();

        // Musicians.
        $freelancer_ids = UnavailableDate::select('individual_id')
        ->where('unavailable_date', '=', $date)
        ->whereNotNull('individual_id')
        ->distinct()->pluck('individual_id')->toArray();

        $freelancer = Individual::select(DB::raw('individual.id as id,individual.uid as uid,individual.categories,individual.lat as lat,individual.lng as lng,users.first_name as first_name,users.last_name as last_name,users.cover as cover, ( '.$values.' * acos( cos( radians('.$lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$lng.') ) + sin( radians('.$lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->join('users','individual.uid','users.id')
        ->where('users.first_name', 'like', '%'.$str.'%')
        // ->where(['individual.status'=>1, 'individual.in_home'=>$solo])
        //->where(['individual.status'=>1, 'individual.have_shop'=>$solo, 'individual.in_home'=>$duo, 'individual.triocheck'=>$trio, 'individual.quartetcheck' => $quartet])
        ->where('individual.status', '=', 1)
        ->where(function ($query) use ($solo, $duo, $trio) {
            if($solo) {
                $query->orWhere('individual.have_shop', '=', $solo);
            }
            if($duo) {
                $query->orWhere('individual.in_home', '=', $duo);
            }
            if($trio) {
                $query->orWhere('individual.triocheck', '=', $trio);
            }
        })
        ->whereNotIn('individual.id', $freelancer_ids)
        ->get();

        foreach($freelancer as $loop){
            $loop->distance = round($loop->distance,2);
        }
        foreach($salon as $loop){
            $loop->distance = round($loop->distance,2);
        }
        $response = [
            'salon'=>$salon,
            'individual'=>$freelancer,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getHomeData(Request $request){
        $validator = Validator::make($request->all(), [
            'lat' => 'required',
            'lng' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $searchQuery = Settings::select('allowDistance','searchResultKind')->first();
        $categories = Category::where(['status'=>1])->get();
        if($searchQuery->searchResultKind == 1){
            $values = 3959; // miles
            $distanceType = 'miles';
        }else{
            $values = 6371; // km
            $distanceType = 'km';
        }

        $salon = Salon::select(DB::raw('salon.id as id,salon.uid as uid,salon.name as name,salon.rating as rating,
        salon.total_rating as total_rating,salon.address as address,salon.cover as cover,salon.lat as salon_lat,salon.lng as salon_lng, ( '.$values.' * acos( cos( radians('.$request->lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$request->lng.') ) + sin( radians('.$request->lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['salon.status'=>1,'salon.in_home'=>1])
        ->get();

        $freelancer = Individual::select(DB::raw('individual.id as id,individual.uid as uid,individual.lat as lat,individual.lng as lng, individual.popular as popular, ( '.$values.' * acos( cos( radians('.$request->lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$request->lng.') ) + sin( radians('.$request->lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['individual.status'=>1,'individual.in_home'=>1])
        ->get();
        foreach($freelancer as $loop){
            $loop->userInfo = User::select('first_name','last_name','cover')->find($loop->uid);
        }

        $top_freelancers = $this->_getTopFreelancer($request->lat, $request->lng);
        $top_salons = $this->_getTopSalon($request->lat, $request->lng);

        $categories =  Category::where('status',1)->get();

        $cities  = Cities::select(DB::raw('cities.id as id,cities.name as name, ( '.$values.' * acos( cos( radians('.$request->lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$request->lng.') ) + sin( radians('.$request->lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['cities.status'=>1])
        ->first();
        $banners =[];
        if (isset($cities) && $cities) {
            $banners =Banners::where('city_id',$cities->id)->get();
        }
        $salonUID = $salon->pluck('uid')->toArray();
        $freelancerUID = $freelancer->pluck('uid')->toArray();
        $uidArray = Arr::collapse([$salonUID,$freelancerUID]);
        $products = Products::where('in_home',1)->WhereIn('freelacer_id',$uidArray)->limit(10)->get();
        $response = [
            'salon'=>$salon,
            'categories'=>$categories,
            'individual'=>$freelancer,
            'topFreelancers'=>$top_freelancers,
            'topSalons'=>$top_salons,
            'cities'=>$cities,
            'banners'=>$banners,
            'products'=>$products,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getHomeDataWeb(Request $request){
        $validator = Validator::make($request->all(), [
            'lat' => 'required',
            'lng' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $searchQuery = Settings::select('allowDistance','searchResultKind')->first();
        $categories = Category::where(['status'=>1])->get();
        if($searchQuery->searchResultKind == 1){
            $values = 3959; // miles
            $distanceType = 'miles';
        }else{
            $values = 6371; // km
            $distanceType = 'km';
        }

        $salon = Salon::select(DB::raw('salon.id as id,salon.uid as uid,salon.name as name,salon.rating as rating,
        salon.total_rating as total_rating,salon.address as address,salon.cover as cover,salon.lat as salon_lat,salon.lng as salon_lng,salon.categories, ( '.$values.' * acos( cos( radians('.$request->lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$request->lng.') ) + sin( radians('.$request->lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['salon.status'=>1,'salon.in_home'=>1])
        ->get();
        foreach($salon as $loop){
            $ids = explode(',',$loop->categories);
            $loop->categories = Category::select('id','name','cover')->WhereIn('id',$ids)->get();
        }

        $freelancer = Individual::select(DB::raw('individual.id as id,individual.fee_start as fee_start,individual.categories,individual.total_rating as total_rating,individual.rating as rating,individual.uid as uid,individual.lat as lat,individual.lng as lng, ( '.$values.' * acos( cos( radians('.$request->lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$request->lng.') ) + sin( radians('.$request->lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['individual.status'=>1,'individual.in_home'=>1])
        ->get();
        foreach($freelancer as $loop){
            $loop->userInfo = User::select('first_name','last_name','cover')->find($loop->uid);
            $ids = explode(',',$loop->categories);
            $loop->categories = Category::select('id','name','cover')->WhereIn('id',$ids)->get();
        }
        // foreach($freelancer as $loop){
        //     $loop->userInfo = User::select('first_name','last_name','cover')->find($loop->uid);
        // }

        $categories =  Category::where('status',1)->get();

        $cities  = Cities::select(DB::raw('cities.id as id,cities.name as name, ( '.$values.' * acos( cos( radians('.$request->lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$request->lng.') ) + sin( radians('.$request->lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['cities.status'=>1])
        ->first();
        $banners =[];
        if (isset($cities) && $cities) {
            $banners =Banners::where('city_id',$cities->id)->get();
        }
        $salonUID = $salon->pluck('uid')->toArray();
        $freelancerUID = $freelancer->pluck('uid')->toArray();
        $uidArray = Arr::collapse([$salonUID,$freelancerUID]);
        $products = Products::where('in_home',1)->WhereIn('freelacer_id',$uidArray)->limit(10)->get();
        $response = [
            'salon'=>$salon,
            'categories'=>$categories,
            'individual'=>$freelancer,
            'cities'=>$cities,
            'banners'=>$banners,
            'products'=>$products,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getTopFreelancer(Request $request){
        $validator = Validator::make($request->all(), [
            'lat' => 'required',
            'lng' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }

        $data = $this->_getTopFreelancer($request->lat, $request->lng);

        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getTopSalon(Request $request){
        $validator = Validator::make($request->all(), [
            'lat' => 'required',
            'lng' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }

        $data = $this->_getTopSalon($request->lat, $request->lng);

        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    private function _getTopFreelancer($lat, $lng) {
        $searchQuery = Settings::select('allowDistance','searchResultKind')->first();
        $categories = Category::where(['status'=>1])->get();
        if($searchQuery->searchResultKind == 1){
            $values = 3959; // miles
            $distanceType = 'miles';
        }else{
            $values = 6371; // km
            $distanceType = 'km';
        }

        $data = Individual::select(DB::raw('individual.id as id,individual.uid as uid,individual.categories,individual.fee_start as fee_start,
        individual.rating as rating,individual.total_rating as total_rating, ( '.$values.' * acos( cos( radians('.$lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$lng.') ) + sin( radians('.$lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['individual.status'=>1,'individual.in_home'=>1])
        ->get();
        foreach($data as $loop){
            $loop->userInfo = User::select('first_name','last_name','cover')->find($loop->uid);
            $ids = explode(',',$loop->categories);
            $loop->categories = Category::select('id','name','cover')->WhereIn('id',$ids)->get();
        }

        return $data;
    }

    private function _getTopSalon($lat, $lng) {
        $searchQuery = Settings::select('allowDistance','searchResultKind')->first();
        $categories = Category::where(['status'=>1])->get();
        if($searchQuery->searchResultKind == 1){
            $values = 3959; // miles
            $distanceType = 'miles';
        }else{
            $values = 6371; // km
            $distanceType = 'km';
        }

        $data = Salon::select(DB::raw('salon.id as id,salon.uid as uid,salon.name as name,salon.rating as rating,
        salon.total_rating as total_rating,salon.address as address,salon.cover as cover,salon.categories as categories, ( '.$values.' * acos( cos( radians('.$lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$lng.') ) + sin( radians('.$lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['salon.status'=>1,'salon.in_home'=>1])
        ->get();

        foreach($data as $loop){
            $ids = explode(',',$loop->categories);
            $loop->categories = Category::select('id','name','cover')->WhereIn('id',$ids)->get();
        }

        return $data;
    }

    public function getDataFromCategory(Request $request){
        $validator = Validator::make($request->all(), [
            'lat' => 'required',
            'lng' => 'required',
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
        $searchQuery = Settings::select('allowDistance','searchResultKind')->first();
        $categories = Category::where(['status'=>1])->get();
        if($searchQuery->searchResultKind == 1){
            $values = 3959; // miles
            $distanceType = 'miles';
        }else{
            $values = 6371; // km
            $distanceType = 'km';
        }

        $salon = Salon::select(DB::raw('salon.id as id,salon.uid as uid,salon.name as name,salon.rating as rating,
        salon.total_rating as total_rating,salon.address as address,salon.cover as cover,salon.categories, ( '.$values.' * acos( cos( radians('.$request->lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$request->lng.') ) + sin( radians('.$request->lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['salon.status'=>1,'salon.in_home'=>1])
        ->whereRaw("find_in_set('".$request->id."',salon.categories)")
        ->get();
        foreach($salon as $loop){
            $ids = explode(',',$loop->categories);
            $loop->categories = Category::select('id','name','cover')->WhereIn('id',$ids)->get();
        }

        $freelancer = Individual::select(DB::raw('individual.id as id,individual.uid as uid,individual.categories, ( '.$values.' * acos( cos( radians('.$request->lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$request->lng.') ) + sin( radians('.$request->lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['individual.status'=>1,'individual.in_home'=>1])
        ->whereRaw("find_in_set('".$request->id."',individual.categories)")
        ->get();
        foreach($freelancer as $loop){
            $loop->userInfo = User::select('first_name','last_name','cover')->find($loop->uid);
            $ids = explode(',',$loop->categories);
            $loop->categories = Category::select('id','name','cover')->WhereIn('id',$ids)->get();
        }

        $response = [
            'salon'=>$salon,
            'individual'=>$freelancer,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getBatchDataFromCategories( Request $request )
    {
        $validator = Validator::make($request->all(), [
            'lat' => 'required',
            'lng' => 'required',
            'ids' => 'required',
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
        $categories = Category::where(['status' => 1])->get();
        if ($searchQuery->searchResultKind == 1) {
            $values = 3959; // miles
            $distanceType = 'miles';
        } else {
            $values = 6371; // km
            $distanceType = 'km';
        }$salon = Salon::select(DB::raw('salon.id as id, salon.uid as uid, salon.name as name, salon.rating as rating,
        salon.total_rating as total_rating, salon.address as address, salon.cover as cover, salon.categories, ( '.$values.' * acos( cos( radians('.$request->lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$request->lng.') ) + sin( radians('.$request->lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['salon.status'=>1, 'salon.in_home'=>1])
        ->where(function ($query) use ($request) {
            foreach ($request->ids as $id) {
                $query->orWhereRaw("FIND_IN_SET('".$id."', salon.categories)");
            }
        })
        ->get();

        foreach ($salon as $loop) {
            $ids = explode(',', $loop->categories);
            $loop->categories = Category::select('id', 'name', 'cover')->WhereIn('id', $ids)->get();
        }

        $freelancer = Individual::select(DB::raw('individual.id as id,individual.uid as uid,individual.categories, ( ' . $values . ' * acos( cos( radians(' . $request->lat . ') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(' . $request->lng . ') ) + sin( radians(' . $request->lat . ') ) * sin( radians( lat ) ) ) ) AS distance'))
            ->having('distance', '<', (int) $searchQuery->allowDistance)
            ->orderBy('distance')
            ->where(['individual.status' => 1, 'individual.in_home' => 1])
            ->where(function ($query) use ($request) {
                foreach ($request->ids as $id) {
                    $query->orWhereRaw("FIND_IN_SET('" . $id . "', individual.categories)");
                }
            })
            ->get();
        foreach ($freelancer as $loop) {
            $loop->userInfo = User::select('first_name', 'last_name', 'cover')->find($loop->uid);
            $ids = explode(',', $loop->categories);
            $loop->categories = Category::select('id', 'name', 'cover')->WhereIn('id', $ids)->get();
        }

        $response = [
            'salon' => $salon,
            'individual' => $freelancer,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getDataFromCategoryWeb(Request $request){
        $validator = Validator::make($request->all(), [
            'lat' => 'required',
            'lng' => 'required',
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
        $searchQuery = Settings::select('allowDistance','searchResultKind')->first();
        $categories = Category::where(['status'=>1])->get();
        if($searchQuery->searchResultKind == 1){
            $values = 3959; // miles
            $distanceType = 'miles';
        }else{
            $values = 6371; // km
            $distanceType = 'km';
        }

        $salon = Salon::select(DB::raw('salon.id as id,salon.uid as uid,salon.name as name,salon.rating as rating,
        salon.total_rating as total_rating,salon.address as address,salon.cover as cover,salon.categories, ( '.$values.' * acos( cos( radians('.$request->lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$request->lng.') ) + sin( radians('.$request->lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['salon.status'=>1,'salon.in_home'=>1])
        ->whereRaw("find_in_set('".$request->id."',salon.categories)")
        ->get();
        foreach($salon as $loop){
            $ids = explode(',',$loop->categories);
            $loop->categories = Category::select('id','name','cover')->WhereIn('id',$ids)->get();
        }

        $freelancer = Individual::select(DB::raw('individual.id as id,individual.uid as uid,individual.categories,individual.fee_start as fee_start,
        individual.rating as rating,individual.total_rating as total_rating, ( '.$values.' * acos( cos( radians('.$request->lat.') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('.$request->lng.') ) + sin( radians('.$request->lat.') ) * sin( radians( lat ) ) ) ) AS distance'))
        ->having('distance', '<', (int)$searchQuery->allowDistance)
        ->orderBy('distance')
        ->where(['individual.status'=>1,'individual.in_home'=>1])
        ->whereRaw("find_in_set('".$request->id."',individual.categories)")
        ->get();
        foreach($freelancer as $loop){
            $loop->userInfo = User::select('first_name','last_name','cover')->find($loop->uid);
            $ids = explode(',',$loop->categories);
            $loop->categories = Category::select('id','name','cover')->WhereIn('id',$ids)->get();
        }

        $response = [
            'salon'=>$salon,
            'individual'=>$freelancer,
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
        $data = Salon::find($request->id)->update($request->all());

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

    public function delete(Request $request){
        $validator = Validator::make($request->all(), [
            'id' => 'required',
            'uid' => 'required',
        ]);
        if ($validator->fails()) {
            $response = [
                'success' => false,
                'message' => 'Validation Error.', $validator->errors(),
                'status'=> 500
            ];
            return response()->json($response, 404);
        }
        $data = Salon::find($request->id);
        $data2 = User::find($request->uid);
        DB::table('commission')->where('uid',$request->uid)->delete();
        if ($data && $data2) {
            $data->delete();
            $data2->delete();
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

    public function getAll(){
        $data = Salon::all();

        if (is_null($data)) {
            $response = [
                'success' => false,
                'message' => 'Data not found.',
                'status' => 404
            ];
            return response()->json($response, 404);
        }
        foreach($data as $loop){
            if($loop && $loop->categories && $loop->categories !=null){
                $ids = explode(',',$loop->categories);
                $cats = Category::WhereIn('id',$ids)->get();
                $loop->web_cates_data = $cats;
            }
            if($loop && $loop->cid && $loop->cid !=null){
                $loop->city_data = Cities::find($loop->cid);
            }
        }
        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getListForOffers(Request $request){
        $salon = Salon::all();
        $individuals =  DB::table('individual')
                ->select('individual.*','users.first_name as first_name','users.last_name as last_name')
                ->join('users','individual.uid','users.id')
                ->get();
        $data = [];

        foreach($salon as $row) {
            array_push($data, (object)[
                    'name' => $row->name,
                    'id' => $row->uid,
            ]);
        }

        foreach($individuals as $row) {
            array_push($data, (object)[
                    'name' => $row->first_name .' '.$row->last_name,
                    'id' => $row->uid,
            ]);
        }
        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function getActiveCities(Request $request){
        $data = Salon::where('status',1)->get();
        $response = [
            'data'=>$data,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function importData(Request $request){
        $request->validate([
            "csv_file" => "required",
        ]);
        $file = $request->file("csv_file");
        $csvData = file_get_contents($file);
        $rows = array_map("str_getcsv", explode("\n", $csvData));
        $header = array_shift($rows);
        foreach ($rows as $row) {
            if (isset($row[0])) {
                if ($row[0] != "") {

                    if(count($header) == count($row)){
                        $row = array_combine($header, $row);
                        $insertInfo =  array(
                            'id' => $row['id'],
                            'name' => $row['name'],
                            'lat' => $row['lat'],
                            'lng' => $row['lng'],
                            'status' => $row['status'],
                        );
                        $checkLead  =  Salon::where("id", "=", $row["id"])->first();
                        if (!is_null($checkLead)) {
                            DB::table('cities')->where("id", "=", $row["id"])->update($insertInfo);
                        }
                        else {
                            DB::table('cities')->insert($insertInfo);
                        }
                    }
                }
            }
        }
        $response = [
            'data'=>'Done',
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }

    public function salonDetails(Request $request){
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
        $data = Salon::find($request->id);

        $userInfo = User::find($data->uid);
        $data['email'] = $userInfo->email;
        $data['mobile'] = $userInfo->mobile;

        $authUserInfo = Auth::user();
        if (!is_null($authUserInfo)) {
            // $authUserInfo = User::where('id',$userId)->first();
            // print_r($authUserInfo->salons);
            $isFavorite = $authUserInfo->individuals->contains('uid', $request->id);
            $data['is_favorite'] = $isFavorite ? 1 : 0;
        }

        $services = Services::select('cate_id')->where(['uid'=>$request->id,'status'=>1])->get()->pluck('cate_id');
        $specialist = Specialist::where('salon_uid',$request->id)->get();
        $categories = Category::where('status',1)->WhereIn('id',$services)->get();
        foreach($categories as $loop){
            $loop->services = Services::where(['status'=>1,'cate_id'=>$loop->id,'uid'=>$request->id])->count();
        }
        $packages =Packages::where('uid',$request->id)->get();
        $response = [
            'data'=>$data,
            'categories'=>$categories,
            'specialist'=>$specialist,
            'packages'=>$packages,
            'success' => true,
            'status' => 200,
        ];
        return response()->json($response, 200);
    }
}
