// Copyright (c) 2014, https://github.com/rhcad/touchvg

package rhcad.touchvg.view.internal;

import rhcad.touchvg.core.GiCoreView;
import android.util.Log;

public class UndoRunnable extends ShapeRunnable {
    public static final int TYPE = 1;
    public static final int UNDO = 0xFFFFFF10;
    public static final int REDO = 0xFFFFFF20;
    private BaseViewAdapter mViewAdapter;

    public UndoRunnable(BaseViewAdapter viewAdapter, String path) {
        super(path, TYPE, viewAdapter.coreView());
        this.mViewAdapter = viewAdapter;
    }

    @Override
    protected boolean beforeStopped() {
        synchronized (GiCoreView.class) {
            boolean ret = mViewAdapter.onStopped(this);
            if (ret) {
                synchronized (mCoreView) {
                    mCoreView.stopRecord(mViewAdapter, true);
                }
            }
            return ret;
        }
    }

    @Override
    protected void afterStopped(boolean normal) {
        mViewAdapter = null;
    }

    @Override
    protected void process(int tick, int doc, int shapes) {
        if (tick == UNDO) {
            synchronized (mCoreView) {
                mCoreView.undo(mViewAdapter);
            }
        } else if (tick == REDO) {
            synchronized (mCoreView) {
                mCoreView.redo(mViewAdapter);
            }
        } else if (!mCoreView.recordShapes(true, tick, doc, shapes)) {
            Log.e(TAG, "Fail to record shapes for undoing, tick=" + tick + ", doc=" + doc);
        }
    }
}
