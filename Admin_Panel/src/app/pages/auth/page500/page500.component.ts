
import { UtilService } from 'src/app/services/util.service';
import { Component } from '@angular/core';

@Component({
  selector: 'app-page500',
  templateUrl: './page500.component.html',
  styleUrls: ['./page500.component.scss']
})
export class Page500Component {

  constructor(
    public util: UtilService,
  ) { }

}
