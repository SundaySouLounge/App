
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { FreelancerStatsComponent } from './freelancer-stats.component';

const routes: Routes = [
  {
    path: '',
    component: FreelancerStatsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class FreelancerStatsRoutingModule { }
