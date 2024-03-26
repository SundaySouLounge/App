
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SalonStatsRoutingModule } from './salon-stats-routing.module';
import { SalonStatsComponent } from './salon-stats.component';
import { NgxPrintModule } from 'ngx-print';
import { NgxSpinnerModule } from 'ngx-spinner';
import { FormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    SalonStatsComponent
  ],
  imports: [
    CommonModule,
    SalonStatsRoutingModule,
    NgxPrintModule,
    NgxSpinnerModule,
    FormsModule
  ]
})
export class SalonStatsModule { }
