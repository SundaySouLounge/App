
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { FreelancerStatsRoutingModule } from './freelancer-stats-routing.module';
import { FreelancerStatsComponent } from './freelancer-stats.component';
import { NgxPrintModule } from 'ngx-print';
import { NgxSpinnerModule } from 'ngx-spinner';
import { FormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    FreelancerStatsComponent
  ],
  imports: [
    CommonModule,
    FreelancerStatsRoutingModule,
    NgxPrintModule,
    NgxSpinnerModule,
    FormsModule
  ]
})
export class FreelancerStatsModule { }
