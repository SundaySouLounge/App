
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ReferralRoutingModule } from './referral-routing.module';
import { ReferralComponent } from './referral.component';
import { ModalModule } from 'ngx-bootstrap/modal';
import { FormsModule } from '@angular/forms';
import { NgxSpinnerModule } from 'ngx-spinner';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';

@NgModule({
  declarations: [
    ReferralComponent
  ],
  imports: [
    CommonModule,
    ReferralRoutingModule,
    ModalModule.forRoot(),
    FormsModule,
    NgxSpinnerModule,
    NgxSpinnerModule,
    NgxSkeletonLoaderModule.forRoot({ animation: 'progress-dark' }),
  ]
})
export class ReferralModule { }
