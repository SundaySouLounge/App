
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SalonStatsComponent } from './salon-stats.component';

const routes: Routes = [
  {
    path: '',
    component: SalonStatsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SalonStatsRoutingModule { }
