
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { FreelancerRequestComponent } from './freelancer-request.component';
const routes: Routes = [
  {
    path: '',
    component: FreelancerRequestComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class FreelancerRequestRoutingModule { }
